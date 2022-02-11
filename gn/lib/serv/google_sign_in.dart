import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();

  var _auth = FirebaseAuth.instance;

  Future googleLogin() async{
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    else {
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future signOut() async{
    googleSignIn.disconnect();
    return _auth.signOut();
  }

}