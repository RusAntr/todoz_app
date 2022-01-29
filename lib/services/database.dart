import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/models/user_model.dart';

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
      {required String projectName,
      required String uid,
      required Color color,
      required String projectCover}) async {
    try {
      await _firestore.collection('users').doc(uid).collection('projects').add({
        'projectName': projectName,
        'dateCreated': Timestamp.now(),
        'isFinished': false,
        'color': color.value.toString(),
        'projectCover': projectCover,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProject(
      String uid, String projectId, List<TodoModel?>? todoModel) async {
    try {
      _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .delete();
      if (todoModel != null) {
        for (var element in todoModel) {
          deleteTodo(element!.todoId, uid, projectId);
        }
      }
    } catch (_) {}
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
      {required String content,
      required String uid,
      String? projectId,
      String? projectName,
      DateTime? dateUntil,
      DateTime? duration}) async {
    if (content.isEmpty == false) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc(projectId)
            .collection('todos')
            .add({
          'dateCreated': DateTime.now(),
          'content': content,
          'isDone': false,
          'projectName': projectName,
          'dateUntil': dateUntil,
          'duration': duration,
          'timePassed': 0
        });
      } catch (e) {
        print(e);
      }
    } else {
      throw (Exception);
    }
  }

  Stream<List<TodoModel>> getAllTodos(String uid) {
    return _firestore
        .collectionGroup('todos')
        //.orderBy('dateCreated', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<TodoModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(TodoModel.fromDocumentSnapshot(element));
      }
      return retVal;
    });
  }

  Future<void> deleteTodo(String todoId, String uid, String projectId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('todos')
          .doc(todoId)
          .delete();
    } catch (_) {}
  }

  Future<void> updateTodo(bool newValue, String uid, String todoId,
      String projectId, String projectName, int timePassed) async {
    if (projectId != 'NoProject') {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc(projectId)
            .collection('todos')
            .doc(todoId)
            .update(
          {
            'isDone': newValue,
            'projectName': projectName,
            'timePassed': timePassed,
          },
        );
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc('NoProject')
            .collection('todos')
            .doc(todoId)
            .update({'isDone': newValue, 'timePassed': timePassed});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateProject(
      Color color,
      String uid,
      String projectCover,
      String projectName,
      String projectId,
      List<TodoModel?>? todoModels) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .update({
        'projectName': projectName,
        'projectCover': projectCover,
        'color': color.value.toString()
      });
      if (todoModels != null) {
        for (var todoModel in todoModels) {
          updateTodo(todoModel!.isDone, uid, todoModel.todoId, projectId,
              projectName, todoModel.timePassed);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
