import 'package:gn/serv/HTTPRequests.dart';
import '../serv/google_sign_in.dart';


class UserRepository{
  final GoogleAuth googleSignIn = GoogleAuth();
  HTTPRequests _requests = HTTPRequests();


  getUser() async{
    await googleSignIn.googleLogin();
    return _requests.getUser(googleSignIn.googleSignIn.currentUser!.id);
  }
}