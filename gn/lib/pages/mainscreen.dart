import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/note_cubit.dart';
import 'package:gn/cubit/note_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gn/pages/edit.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/data/note_repository.dart';
import 'package:gn/data/user_repository.dart';
import 'package:gn/wid/task-list.dart';

class MainScreen extends StatefulWidget {
  // MainScreen({this.googleAccount});

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
    NoteRepository noteRepository = new NoteRepository();
    UserRepository userRepository = new UserRepository();
    return BlocProvider(
      create: (context) => NoteCubit(noteRepository),
      child: SafeArea(
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
                    // Row(
                    //   children: [
                    //     Text(
                    //       NoteCubit(noteRepository).googleSign.toString(),
                    //       style: TextStyle(fontSize: 10),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          try {
                            final googleAccount = new GoogleAuth();
                            googleAccount.signOut();
                            Navigator.of(context).pushReplacementNamed("/auth");
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
          body: BlocBuilder<NoteCubit, NoteState>(
            builder: (context, state) {
              if (state is NoteLoadingState) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    ]);
              } else if (state is NoteEmptyState) {
                NoteCubit noteCubit = BlocProvider.of<NoteCubit>(context);
                noteCubit.fetchNotes();
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    ]);
              } else if (state is NoteLoadedState) {
                var notesList = state.loadedNote.toList();
                return TaskList(tasks: notesList);
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text('Ошибка'),
                          )
                        ],
                      ),
                    ]);
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/create');
              },
              child: const Icon(Icons.add_box)),
        ),
      ),
    );
  }
}
