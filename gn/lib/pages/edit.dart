import 'package:gn/pages/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gn/serv/HTTPRequests.dart';

class EditScreen extends StatefulWidget {
  final googleAccount;
  var note;

  EditScreen({this.googleAccount, this.note});

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
    String noticeText = widget.note.note;
    var textControl = TextEditingController()..text = widget.note.note;
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
                      onPressed: () {
                        try {
                          request.deleteNote(
                              context, widget.note, widget.googleAccount);
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
                            request.editNote(context, textControl.text,
                                widget.note, widget.googleAccount);
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
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (__) => new MainScreen(
                                      // googleAccount: widget.googleAccount
                                  )));
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
