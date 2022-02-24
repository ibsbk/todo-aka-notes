import 'package:gn/serv/HTTPRequests.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../serv/google_sign_in.dart';

class NoteRepository{
  HTTPRequests _notes = HTTPRequests();
  final GoogleAuth googleSignIn = GoogleAuth();
  getAllNotes() async{
    await googleSignIn.googleLogin();
    return _notes.getAllNotes(googleSignIn.googleSignIn.currentUser!.id);
  }
}