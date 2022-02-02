import 'package:flutter/material.dart';
import 'package:gn/pages/auth.dart';
import 'package:gn/google_sign_in.dart';
import 'package:gn/pages/mainscreen.dart';
import 'package:gn/pages/create.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:io';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child:MaterialApp(
    theme: ThemeData(primaryColor: Colors.black,
        accentColor: Colors.grey),
    initialRoute: '/auth',
    routes: {
      '/main': (context) => MainScreen(),
      '/auth': (context) => AuthScreen(),
      '/create': (context) => CreateSrceen(),
    },

  )
  )
  );
  
}

