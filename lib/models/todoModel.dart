// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String content;
  late String todoId;
  late String projectName;
  late Timestamp dateCreated;
  late bool isDone;

  TodoModel(
      {required this.content,
      required this.todoId,
      required this.projectName,
      required this.dateCreated,
      required this.isDone});

  TodoModel.fromDocumentSnapshot(DocumentSnapshot? documentSnapshot) {
    content = documentSnapshot?['content'];
    todoId = documentSnapshot!.id;
    projectName = documentSnapshot['projectName'];
    dateCreated = documentSnapshot['dateCreated'];
    isDone = documentSnapshot['isDone'];
  }
}
