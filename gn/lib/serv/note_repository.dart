import 'package:gn/serv/HTTPRequests.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteRepository{
  HTTPRequests _notes = HTTPRequests();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  getAllNotes() => _notes.getAllNotes(googleSignIn.currentUser);
}