import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todoz_app/models/projectModel.dart';
import 'package:todoz_app/models/todoModel.dart';
import 'package:todoz_app/models/userModel.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection('users').doc(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addProject(
      {@required String? projectName,
      @required String? uid,
      @required Color? color,
      @required String? projectCover}) async {
    try {
      await _firestore.collection('users').doc(uid).collection('projects').add({
        'projectName': projectName!,
        'dateCreated': Timestamp.now(),
        'isFinished': false,
        'color': color!.value.toString(),
        'projectCover': projectCover!,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ProjectModel>> getProjects(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('projects')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ProjectModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(ProjectModel.fromDocumentSnapshot(element));
      }
      return retVal;
    });
  }

  Future<void> addTodo(
      {@required String? content,
      @required String? uid,
      @required String? projectId,
      @required String? projectName}) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('todos')
          .add({
        'dateCreated': Timestamp.now(),
        'content': content,
        'isDone': false,
        'projectName': projectName
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<TodoModel>> getAllTodos(String uid) {
    return _firestore
        .collectionGroup('todos')
        .snapshots()
        .map((QuerySnapshot query) {
      List<TodoModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(TodoModel.fromDocumentSnapshot(element));
      }
      return retVal;
    });
  }

  Future<void> updateTodo(bool newValue, String uid, String todoId,
      String projectId, String? projectName) async {
    if (projectId != 'NoProject') {
      try {
        _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc(projectId)
            .collection('todos')
            .doc(todoId)
            .update({'isDone': newValue, 'projectName': projectName});
      } catch (e) {
        print(e);
      }
    } else {
      try {
        _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc('NoProject')
            .collection('todos')
            .doc(todoId)
            .update({'isDone': newValue});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateProject(Color color, String uid, String projectCover,
      String projectName, String projectId, List<TodoModel?>? todoModel) async {
    try {
      _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .update({
        'projectName': projectName,
        'projectCover': projectCover,
        'color': color.value.toString()
      });
      if (todoModel != null) {
        for (var element in todoModel) {
          updateTodo(
              element!.isDone, uid, element.todoId, projectId, projectName);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
