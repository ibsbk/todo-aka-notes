import 'package:gn/pages/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gn/serv/google_sign_in.dart';

class CreateScreen extends StatefulWidget {
  // final googleAccount;

  // CreateScreen({this.googleAccount});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
  }

  final textControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    HTTPRequests request = new HTTPRequests();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('create notice'),
          ),
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
                    maxLines: 20,
                    onChanged: (String str) {
                      textControl.text = str;
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
                      onPressed: () async {
                        try {
                          GoogleAuth googleSignIn = new GoogleAuth();
                          await googleSignIn.googleLogin();
                          await request.createNote(context, textControl.text,
                              googleSignIn.googleSignIn.currentUser);
                          Navigator.pushReplacementNamed(context, '/main');
                        } catch (e) {
                          print(e);
                        }
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
