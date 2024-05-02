import 'package:flutter/material.dart';
import 'package:notes_app/pages/add.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/pages/Urgent.dart';
import 'package:notes_app/pages/Important.dart';
import 'package:notes_app/pages/Casual.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (context){
          return HomePage();
        },
        "/Urgent": (context) => UrgentNotesPage(),
        "/Important": (context) => ImportantNotesPage(),
        "/Casual": (context) => CasualNotesPage(),
      },
      theme: ThemeData(
          primarySwatch: Colors.lightGreen
      ),
      initialRoute: "/home",
    );
  }
}





