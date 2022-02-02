import 'package:gn/pages/mainscreen.dart';
import 'package:gn/pages/auth.dart';
import 'package:gn/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
// import 'package:gn/notifications.dart';
// import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateSrceen extends StatefulWidget {
  final prov;

  CreateSrceen({this.prov});

  @override
  _CreateSrceenState createState() => _CreateSrceenState();
}


call(String text) {
  // NotificationsS.showNotification(
  //   title: 'wake up',
  //   body: text,
  // );
  print(text);
}

class _CreateSrceenState extends State<CreateSrceen> {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
    print(widget.prov.email);
    HttpOverrides.global = MyHttpOverrides();
  }

  final textControl = TextEditingController();

  DateTime date = DateTime.now();
  String dateFormated = 'Дата';

  String noticeText = '';

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (newDate == null) return;

    setState(() {
      date = newDate;
      dateFormated = DateFormat('dd/MM/yy').format(date);
    });
  }

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
                Container(
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            pickDate(context);
                          },
                          child: Text('$dateFormated')),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text('Заметка'),
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
                    maxLines: 9,
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
                          print('FFFFFFFFFFFFFFFFFFFFFFFFFFF');
                          var url = Uri.parse(
                              'https://10.0.2.2:7168/api/notes/add_note');
                          print(url);
                          var jsonString = '{}';
                          var now = DateTime.now().toIso8601String();
                          print(now.toString());
                          var note = jsonEncode({"note": noticeText,"created_at": now.toString(),"user_id": 92});
                          var response = await http.put(url, headers: { "Content-Type" : "application/json"}, body: note);
                          print('Response status: ${response.statusCode}');
                          print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
                          print('Response body: ${response.body}');
                          print('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');
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
                                  builder: (__) =>
                                      new MainScreen(prov: widget.prov)));
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
