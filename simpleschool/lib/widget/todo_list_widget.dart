import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleschool/provider/entry.dart';
import 'dart:core';

class TodoListWidget extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    final provider = Provider.of<EntryProvider>(context);
    final todos = provider.entries;

    return todos.isEmpty
    ? Center(child: Text("No Items."))
    : ListView.seperated(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(8),
      seperatorBuilder: (context, index) => Container(height: 8),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Text(todo.title);
      }
    );
  }
}