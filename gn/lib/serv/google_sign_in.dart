import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();

  var _auth = FirebaseAuth.instance;

  Future googleLogin() async{
    print('1');
    final googleUser = await googleSignIn.signIn();
    print('2');
    if (googleUser == null) {
      return;
    }
    print('3');
    final googleAuth = await googleUser.authentication;
    print('4');
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  void signOut() async{
    final googleUser = await googleSignIn.signIn();
    googleSignIn.disconnect();
    _auth.signOut();
  }

}