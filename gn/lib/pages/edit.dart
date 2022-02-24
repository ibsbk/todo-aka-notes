import 'package:gn/mod/Note.dart';
import 'package:gn/pages/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
  }

  HTTPRequests request = new HTTPRequests();

  @override
  Widget build(BuildContext context) {
    final GoogleAuth googleAccount = new GoogleAuth();
    final note = ModalRoute.of(context)!.settings.arguments as Note;
    String noticeText = '';
    var textControl = TextEditingController()..text = note.note!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('edit notice'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await googleAccount.googleLogin();
                          await request.deleteNote(
                              note, googleAccount.googleSignIn.currentUser!.id);
                          Navigator.pushReplacementNamed(context, '/main');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('Удалить'))
                ],
              ),
            ],
          )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text('Задача'),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: textControl,
                    maxLines: 20,
                    onChanged: (String str) {
                      noticeText = str;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          try {
                            request.editNote(context, textControl.text, note,
                                googleAccount.googleSignIn.currentUser!.id);
                          } catch (e) {
                            print(e);
                          }
                        });
                      },
                      child: Text('Сохранить'),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pushReplacementNamed(context, '/main');
                        });
                      },
                      child: Text('Отмена'),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
