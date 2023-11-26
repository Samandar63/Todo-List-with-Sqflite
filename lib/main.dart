import 'package:flutter/material.dart';
import 'package:todo_sqflite/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteKeeper",
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),

      home: NoteList(),
    );
  }
}