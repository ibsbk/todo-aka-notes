import 'package:flutter/material.dart';
import 'package:gn/pages/auth.dart';
import 'package:gn/pages/create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gn/pages/edit.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  final googleAccount;

  MainScreen({this.googleAccount});

  @override
  _MainScreenState createState() => _MainScreenState();
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
    HTTPRequests request = new HTTPRequests();
    var notesList = [];
    try {
      request.getAllNotes(widget.googleAccount!.id).then((value) {
        value.forEach((element) {
          notesList.add(element);
        });
      });
    } catch (e) {
      print(e);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        try {
                          final googleAccount = new GoogleAuth();
                          googleAccount.signOut();
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (__) => new AuthScreen()));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('Выйти'))
                ],
              )
            ],
          )),
        ),
        body: Container(
            child: FutureBuilder(
                future: request.getAllNotes(widget.googleAccount!.id),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasData) {
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
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  onTap: () {
                                    setState(() {
                                      request.isDoneChange(
                                          notesList[index], false);
                                    });
                                  },
                                  onLongPress: () {
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (__) => new EditScreen(
                                                googleAccount:
                                                    widget.googleAccount,
                                                note: notesList[index])));
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
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  onTap: () {
                                    setState(() {
                                      request.isDoneChange(
                                          notesList[index], true);
                                    });
                                  },
                                  onLongPress: () {
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (__) => new EditScreen(
                                                  googleAccount:
                                                      widget.googleAccount,
                                                  note: notesList[index],
                                                )));
                                  },
                                ),
                              );
                            }
                          });
                    } else {
                      return Center(
                        child: Text('no data'),
                      );
                    }
                  } catch (e) {
                    return Center(
                      child: Text(e.toString()),
                    );
                  }
                })),
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
