// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  // late String? projectId;
  late String? projectName;
  late Timestamp? dateCreated;
  late bool? isFinished;

  ProjectModel(
      {
      //this.projectId,
      this.projectName,
      this.dateCreated,
      this.isFinished});

  ProjectModel.fromDocumentSnapshot(DocumentSnapshot? documentSnapshot) {
    // projectId = documentSnapshot?.id;
    projectName = documentSnapshot?['projectName'];
    dateCreated = documentSnapshot?['dateCreated'];
    isFinished = documentSnapshot?['isFinished'];
  }
}
