import 'package:flutter/material.dart';
import 'package:gn/pages/auth.dart';
import 'package:gn/google_sign_in.dart';
import 'package:gn/pages/mainscreen.dart';
import 'package:gn/pages/create.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gn/pages/create.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        initialRoute: '/auth',
        routes: {
          '/main': (context) => MainScreen(),
          '/auth': (context) => AuthScreen(),
          '/create': (context) => CreateScreen(),
        },
      )));
}
