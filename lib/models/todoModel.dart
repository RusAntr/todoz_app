// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String? content;
  late String? todoId;
  late Timestamp? dateCreated;
  late bool? isDone;

  TodoModel({this.content, this.todoId, this.dateCreated, this.isDone});

  TodoModel.fromDocumentSnapshot(DocumentSnapshot? documentSnapshot) {
    content = documentSnapshot?['content'];
    todoId = documentSnapshot?.id;
    dateCreated = documentSnapshot?['dateCreated'];
    isDone = documentSnapshot?['isDone'];
  }
}
