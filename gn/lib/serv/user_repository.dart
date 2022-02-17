import 'package:gn/serv/HTTPRequests.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  HTTPRequests _requests = HTTPRequests();
  getUser() => _requests.auth(googleSignIn.currentUser!.id);
}