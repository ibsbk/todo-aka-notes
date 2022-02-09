import 'package:flutter/material.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/serv/HTTPRequests.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

HTTPRequests request = new HTTPRequests();

void auth(context) async {
  final googleAccount = new GoogleAuth();
  await googleAccount.googleLogin();

  if (googleAccount.googleSignIn.currentUser != null) {
    request.auth(context, googleAccount.googleSignIn.currentUser);
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    try {
      auth(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final googleAuth = new GoogleAuth();
    googleAuth.googleLogin();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('auth'),
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    try {
                      auth(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Google Sign In'))
            ],
          ),
        ]),
      ),
    );
  }
}
