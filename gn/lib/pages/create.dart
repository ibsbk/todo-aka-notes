import 'package:gn/pages/mainscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';

class CreateScreen extends StatefulWidget {
  final googleAccount;

  CreateScreen({this.googleAccount});

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
    print(widget.googleAccount.email);
  }

  final textControl = TextEditingController();

  DateTime date = DateTime.now();
  String dateFormated = 'Дата';

  String noticeText = '';

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () async {
                        setState(() async {
                          if (noticeText != '') {
                            var url = Uri.parse(
                                'https://10.0.2.2:7168/api/notes/add_note');
                            print(url);
                            var now = DateTime.now().toIso8601String();
                            print(now.toString());
                            var userIdUrl = Uri.parse(
                                'https://10.0.2.2:7168/api/users/get_userId/' +
                                    widget.googleAccount!.id);
                            var userIdResponse = await http.get(userIdUrl,
                                headers: {"Content-Type": "text"});
                            var note = jsonEncode({
                              "note": noticeText,
                              "created_at": now.toString(),
                              "user_id": userIdResponse.body.toString(),
                              "isDone": false,
                            });
                            var response = await http.put(url,
                                headers: {"Content-Type": "application/json"},
                                body: note);
                            if (response.statusCode == 200) {
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (__) => new MainScreen(
                                          googleAccount:
                                              widget.googleAccount)));
                            }
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
                                      googleAccount: widget.googleAccount)));
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
