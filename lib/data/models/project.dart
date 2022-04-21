import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  late String projectName;
  late Timestamp dateCreated;
  late bool isFinished;
  late String color;
  late String projectCover;
  late String projectId;

  ProjectModel({
    required this.color,
    required this.projectName,
    required this.dateCreated,
    required this.isFinished,
    required this.projectCover,
    required this.projectId,
  });

  ProjectModel.fromDocumentSnapshot(DocumentSnapshot? documentSnapshot) {
    projectName = documentSnapshot?['projectName'];
    dateCreated = documentSnapshot?['dateCreated'];
    isFinished = documentSnapshot?['isFinished'];
    color = documentSnapshot?['color'];
    projectCover = documentSnapshot?['projectCover'];
    projectId = documentSnapshot!.id;
  }
}
