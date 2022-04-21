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
  late String userId;

  TodoModel({
    required this.content,
    required this.todoId,
    required this.projectName,
    required this.dateCreated,
    required this.isDone,
    this.dateUntil,
    this.duration,
    required this.timePassed,
    required this.userId,
  });

  TodoModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    content = documentSnapshot['content'];
    todoId = documentSnapshot.id;
    projectName = documentSnapshot['projectName'];
    dateCreated = documentSnapshot['dateCreated'];
    isDone = documentSnapshot['isDone'];
    dateUntil = documentSnapshot['dateUntil'];
    duration = documentSnapshot['duration'];
    timePassed = documentSnapshot['timePassed'];
    userId = documentSnapshot['userId'];
  }

  TodoModel copyWith({
    String? content,
    String? todoId,
    String? projectName,
    Timestamp? dateCreated,
    bool? isDone,
    Timestamp? dateUntil,
    Timestamp? duration,
    int? timePassed,
    String? userId,
  }) {
    return TodoModel(
      content: content ?? this.content,
      todoId: todoId ?? this.todoId,
      projectName: projectName ?? this.projectName,
      dateCreated: dateCreated ?? this.dateCreated,
      isDone: isDone ?? this.isDone,
      dateUntil: dateUntil ?? this.dateUntil,
      duration: duration ?? this.duration,
      timePassed: timePassed ?? this.timePassed,
      userId: userId ?? this.userId,
    );
  }
}
