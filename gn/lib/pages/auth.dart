import 'package:flutter/material.dart';
import 'package:gn/google_sign_in.dart';
import 'package:gn/pages/mainscreen.dart';
import 'package:gn/main.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.googleLogin().then((value) {
      if (provider.googleSignIn.currentUser != null) {
        print(provider.googleSignIn.currentUser!.email);
        print('FFFFFFFFFFFFFFFFFFFFFFFFFFF');
        var url = Uri.parse('https://10.0.2.2:7168/api/users/get_user/' +
            provider.googleSignIn.currentUser!.id);
        print(url);
        var response = http.get(url,
            headers: {"Content-Type": "application/json"}).then((value) {
          if (value.statusCode != 200) {
            var url = Uri.parse('https://10.0.2.2:7168/api/users/add_user');
            print(url);
            var jsonString = '{}';
            var user = jsonEncode({
              "google_id": provider.googleSignIn.currentUser!.id,
              "name": provider.googleSignIn.currentUser!.displayName
            });
            print(user);
            var response = http
                .put(url,
                    headers: {"Content-Type": "application/json"}, body: user)
                .then((value) => {
                      print(value.statusCode),
                      print(value.body),
                      print(1111),
                      if (value.statusCode == 200)
                        {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (__) => new MainScreen(
                                      prov:
                                          provider.googleSignIn.currentUser))),
                        }
                    });
          } else {
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (__) => new MainScreen(
                        prov: provider.googleSignIn.currentUser)));
          }
        });
      }
      print(123444);
    });
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
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                      if (provider.googleSignIn.currentUser != null) {
                        print('cool');
                        print(provider.googleSignIn.currentUser!.id);
                        //Navigator.of(context).pushReplacementNamed('/main');
                        Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new MainScreen(
                                    prov: provider.googleSignIn.currentUser)));
                      } else {
                        print('not cool');
                      }
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
