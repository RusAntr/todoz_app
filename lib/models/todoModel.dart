// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoz_app/widgets/createTodo.dart';

class TodoModel {
  late String? content;
  late String? todoId;
  late String? projectName;
  late Timestamp? dateCreated;
  late bool? isDone;

  TodoModel(
      {this.content,
      this.todoId,
      this.projectName,
      this.dateCreated,
      this.isDone});

  TodoModel.fromDocumentSnapshot(DocumentSnapshot? documentSnapshot) {
    content = documentSnapshot?['content'];
    todoId = documentSnapshot?.id;
    projectName = documentSnapshot?['projectName'];
    dateCreated = documentSnapshot?['dateCreated'];
    isDone = documentSnapshot?['isDone'];
  }

  void openCreateTodo(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              children: [CreateTodo()],
            ));
  }
}
