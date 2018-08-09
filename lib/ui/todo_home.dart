import 'package:flutter/material.dart';
import 'package:simple_to_do_app/ui/todo_screen.dart';

class ToDoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("ToDo App"),
        backgroundColor: Colors.black54,
      ),
      body: ToDoScreen(),
    );
  }
}
