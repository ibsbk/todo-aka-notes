import 'package:flutter/material.dart';
import 'package:gn/pages/auth.dart';
import 'package:gn/pages/mainscreen.dart';
import 'package:gn/pages/edit.dart';
import 'package:gn/pages/create.dart';
import 'package:firebase_core/firebase_core.dart';
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

  runApp(MaterialApp(
    initialRoute: '/auth',
    routes: {
      '/main': (context) => MainScreen(),
      '/auth': (context) => AuthScreen(),
      '/create': (context) => CreateScreen(),
      '/edit': (context) => EditScreen(),
    },
  ));
}
