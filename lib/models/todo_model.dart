import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String content;
  late String todoId;
  late String projectName;
  late Timestamp dateCreated;
  late bool isDone;
  late Timestamp? dateUntil;
  late Timestamp? duration;
  late int timePassed;

  TodoModel(
      {required this.content,
      required this.todoId,
      required this.projectName,
      required this.dateCreated,
      required this.isDone,
      this.dateUntil,
      this.duration,
      required this.timePassed});

  TodoModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    content = documentSnapshot['content'];
    todoId = documentSnapshot.id;
    projectName = documentSnapshot['projectName'];
    dateCreated = documentSnapshot['dateCreated'];
    isDone = documentSnapshot['isDone'];
    dateUntil = documentSnapshot['dateUntil'];
    duration = documentSnapshot['duration'];
    timePassed = documentSnapshot['timePassed'];
  }
}
