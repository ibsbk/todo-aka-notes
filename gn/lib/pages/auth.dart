import 'package:flutter/material.dart';
import 'package:gn/google_sign_in.dart';
import 'package:gn/pages/mainscreen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

void auth(context) async {
  final googleAccount = Provider.of<GoogleSignInProvider>(context, listen: false);
  await googleAccount.googleLogin();

  if (googleAccount.googleSignIn.currentUser != null) {
    print(googleAccount.googleSignIn.currentUser!.email);
    print('FFFFFFFFFFFFFFFFFFFFFFFFFFF');
    var getUserUrl = Uri.parse('https://10.0.2.2:7168/api/users/get_user/' +
        googleAccount.googleSignIn.currentUser!.id);
    print(getUserUrl);
    var getUserResponse = await http
        .get(getUserUrl, headers: {"Content-Type": "application/json"});
    if (getUserResponse.statusCode != 200) {
      var addUserUrl = Uri.parse('https://10.0.2.2:7168/api/users/add_user');
      print(addUserUrl);
      var user = jsonEncode({
        "google_id": googleAccount.googleSignIn.currentUser!.id,
        "name": googleAccount.googleSignIn.currentUser!.displayName
      });
      print(user);
      var addUserResponse = await http.put(addUserUrl,
          headers: {"Content-Type": "application/json"}, body: user);
      print(addUserResponse.statusCode);
      print(addUserResponse.body);
      print(1111);
      if (addUserResponse.statusCode == 200) {
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (__) =>
                new MainScreen(
                    googleAccount: googleAccount.googleSignIn.currentUser)));
  }
  } else {
  Navigator.pushReplacement(
  context,
  new MaterialPageRoute(
  builder: (__) =>
  new MainScreen(googleAccount: googleAccount.googleSignIn.currentUser)));
  }
}
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    auth(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.googleLogin();
    return Provider<GoogleSignInProvider>(
      create: (context) => provider,
      child: SafeArea(
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
                      auth(context);
                    },
                    child: Text('Google Sign In'))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
