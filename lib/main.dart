import 'package:flutter/material.dart';
import 'package:simple_to_do_app/ui/todo_home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ToDo App',
      home: new ToDoHome(),
    );
  }
}
