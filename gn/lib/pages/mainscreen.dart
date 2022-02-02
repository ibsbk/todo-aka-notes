import 'package:flutter/material.dart';
import 'package:gn/pages/create.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class MainScreen extends StatefulWidget {
  final prov;

  MainScreen({this.prov});

  @override
  _MainScreenState createState() => _MainScreenState();
}

Future<void> callback() async {
  // NotificationsS.showNotification(title: '11', body: 'nnnn', payload: '111');
  print('12311');
}

class _MainScreenState extends State<MainScreen> {
  @override

  void initFirebase() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Column(
              children: [
                Row(
                  children: [Text('getnotices')],
                ),
                Row(
                  children: [
                    Text(widget.prov.email,
                    style: TextStyle(fontSize: 10),)
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(

        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context, new
              MaterialPageRoute(builder:  (__)
              => new CreateSrceen(prov: widget.prov)
              )
              );
            },
            child: const Icon(Icons.add_box)),
      ),
    );
  }
}
