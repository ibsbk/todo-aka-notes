import 'package:flutter/material.dart';
import 'package:gn/pages/create.dart';
import 'package:gn/Note.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  final googleAccount;
  var notesList = [];

  MainScreen({this.googleAccount});

  @override
  _MainScreenState createState() => _MainScreenState();
}

Future<List> getAllNotes(google_id) async {
  var allNotes = [];
  var getUserUrl =
      Uri.parse('https://10.0.2.2:7168/api/users/get_userId/' + google_id);
  print(getUserUrl);
  var getUserResponse =
      await http.get(getUserUrl, headers: {"Content-Type": "application/json"});
  var getAllNotesUrl = Uri.parse(
      'https://10.0.2.2:7168/api/notes/get_user_notes/' + getUserResponse.body);
  var getAllNotesResponse = await http
      .get(getAllNotesUrl, headers: {"Content-Type": "application/json"});
  var userMap = jsonDecode(getAllNotesResponse.body);
  userMap.forEach((e) {
    Note note = Note.fromJson(e);
    allNotes.add(note);
  });
  return allNotes;
}

class _MainScreenState extends State<MainScreen> {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  void initState() {
    super.initState();
    initFirebase();
  }



  @override
  Widget build(BuildContext context) {
    var notesList = [];
    var n = getAllNotes(widget.googleAccount!.id).then((value) {
      value.forEach((element) {
        notesList.add(element);
      });
    });
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Column(
              children: [
                Row(
                  children: [Text('todo')],
                ),
                Row(
                  children: [
                    Text(
                      widget.googleAccount.email,
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
            child: FutureBuilder(
          future: getAllNotes(widget.googleAccount!.id),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    if (notesList[index].isdone == true) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            color: Colors.green),
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(notesList[index].note.toString()),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onLongPress: () {
                            setState(() {
                              notesList[index].isdone = false;
                              var url = Uri.parse(
                                  'https://10.0.2.2:7168/api/notes/edit_note');
                              var body = {
                                'id': notesList[index].id,
                                'note': notesList[index].note,
                                'created_at':
                                notesList[index].created_at.toString(),
                                'user_id': notesList[index].user_id,
                                'isdone': notesList[index].isdone,
                              };
                              var z = jsonEncode(body);
                              print(z);
                              var response = http
                                  .patch(url,
                                  headers: {
                                    "Content-Type": "application/json"
                                  },
                                  body: z)
                                  .then((value) {
                                print(value.body);
                              });
                            });
                          },
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            color: Colors.red),
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(notesList[index].note.toString()),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onLongPress: () {
                            setState(() {
                              notesList[index].isdone = true;
                              var url = Uri.parse(
                                  'https://10.0.2.2:7168/api/notes/edit_note');
                              var body = {
                                'id': notesList[index].id,
                                'note': notesList[index].note,
                                'created_at':
                                notesList[index].created_at.toString(),
                                'user_id': notesList[index].user_id,
                                'isdone': notesList[index].isdone,
                              };
                              var z = jsonEncode(body);
                              print(z);
                              var response = http
                                  .patch(url,
                                  headers: {
                                    "Content-Type": "application/json"
                                  },
                                  body: z)
                                  .then((value) {
                                print(value.body);
                                print(value.statusCode);
                              });
                            });
                          },
                        ),
                      );
                    }
                  });
            } else{
              return Center(child: Text('no data'),);
            }

          },
        )),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (__) => new CreateScreen(
                          googleAccount: widget.googleAccount)));
            },
            child: const Icon(Icons.add_box)),
      ),
    );
  }
}
