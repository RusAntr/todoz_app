import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todoz_app/core/custom_snackbars.dart';
import '../models/models.dart';

class FirestoreApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String currentUserId(UserModel user) => user.id!;

  /// Creates a new document to store [UserModel] in [FirebaseFirestore]
  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(
        {
          'name': user.name,
          'email': user.email,
        },
      );
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
      return false;
    }
    return true;
  }

  /// Returns a [UserModel]
  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection('users').doc(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
      rethrow;
    }
  }

  /// Updates a document field 'name' that stores [UserModel]'s name property
  Future<void> updateUsername(
    String uid,
    String newName,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).update(
        {
          'name': newName,
        },
      );
    } on FirebaseException catch (error) {
      CustomSnackbars.error(error.code, error.message!);
    }
  }

  /// Creates a new document to store [ProjectModel] in [FirebaseFirestore]
  Future<void> addProject({
    required String projectName,
    required String uid,
    required Color color,
    required String projectCover,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('projects').add(
        {
          'projectName': projectName,
          'dateCreated': Timestamp.now(),
          'isFinished': false,
          'color': color.value.toString(),
          'projectCover': projectCover,
        },
      );
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Deletes document that stores [ProjectModel]
  Future<void> deleteProject({
    required String uid,
    required String projectId,
    required List<TodoModel?>? todoModels,
  }) async {
    try {
      _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .delete();
      if (todoModels != null) {
        for (var element in todoModels) {
          deleteTodo(
            todoId: element!.todoId,
            uid: uid,
            projectId: projectId,
          );
        }
      }
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Returns a stream of a list of [ProjectModel]s
  Stream<List<ProjectModel>> getProjects(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('projects')
        .orderBy(
          'dateCreated',
          descending: true,
        )
        .snapshots()
        .map(
      (QuerySnapshot query) {
        List<ProjectModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(
            ProjectModel.fromDocumentSnapshot(element),
          );
        }
        return retVal;
      },
    );
  }

  /// Returns a stream of [UserModel]
  Stream<UserModel> getUserStream(String uid) {
    return _firestore.collection('users').snapshots().map(
      (QuerySnapshot query) {
        List<UserModel> retval = [];
        for (var item in query.docs) {
          retval.add(
            UserModel.fromDocumentSnapshot(documentSnapshot: item),
          );
        }
        return retval.singleWhere((element) => element.id == uid);
      },
    );
  }

  /// Creates a new document to store [TodoModel] in [FirebaseFirestore]
  Future<void> addTodo({
    required String content,
    required String uid,
    required String projectId,
    required String projectName,
    DateTime? dateUntil,
    DateTime? duration,
  }) async {
    if (content.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc(projectId)
            .collection('todos')
            .add(
          {
            'dateCreated': DateTime.now(),
            'content': content,
            'isDone': false,
            'projectName': projectName,
            'dateUntil': dateUntil,
            'duration': duration,
            'timePassed': 0,
            'userId': uid,
          },
        );
      } on FirebaseException catch (error) {
        CustomSnackbars.error(error.code, error.message!);
      }
    } else {
      CustomSnackbars.error(
        'emptyErrorTitle'.tr,
        'emptyErrorMessage'.tr,
      );
    }
  }

  /// Returns a stream of a list of [TodoModel]s
  Stream<List<TodoModel>> getAllTodos(String uid) {
    return _firestore
        .collectionGroup('todos')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(
      (QuerySnapshot query) {
        List<TodoModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(element));
        }
        return retVal;
      },
    );
  }

  /// Recreates deleted document that stores [TodoModel]
  Future<void> restoreTodo({
    required TodoModel deletedTodoModel,
    required String uid,
    required String projectId,
  }) async {
    if (deletedTodoModel.content.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc(projectId)
            .collection('todos')
            .add(
          {
            'dateCreated': deletedTodoModel.dateCreated,
            'content': deletedTodoModel.content,
            'isDone': deletedTodoModel.isDone,
            'projectName': deletedTodoModel.projectName,
            'dateUntil': deletedTodoModel.dateUntil,
            'duration': deletedTodoModel.duration,
            'timePassed': deletedTodoModel.timePassed,
            'userId': uid,
          },
        );
      } on FirebaseException catch (error) {
        CustomSnackbars.error(
          error.code,
          error.message!,
        );
      }
    } else {
      CustomSnackbars.error(
        'emptyErrorTitle'.tr,
        'emptyErrorMessage'.tr,
      );
    }
  }

  /// Deletes a document that stores [TodoModel] in [FirebaseFirestore]
  Future<void> deleteTodo({
    required String todoId,
    required String uid,
    required String projectId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('todos')
          .doc(todoId)
          .delete();
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Updates documemnt fields that store properties of [TodoModel]
  Future<void> updateTodo({
    required bool newValue,
    required String uid,
    required String todoId,
    required String projectId,
    required String projectName,
    required int timePassed,
  }) async {
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
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }

  /// Updates document fields that store properties of [ProjectModel] in [FirebaseFirestore]. If the document
  /// contains a 'todos' collection then documents inside the collection that store [TodoModel]s will also be updated
  Future<void> updateProject({
    required Color color,
    required String uid,
    required String projectCover,
    required String projectName,
    required String projectId,
    List<TodoModel?>? todoModels,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .update(
        {
          'projectName': projectName,
          'projectCover': projectCover,
          'color': color.value.toString()
        },
      );
      if (todoModels != null) {
        for (var todoModel in todoModels) {
          updateTodo(
            newValue: todoModel!.isDone,
            uid: uid,
            todoId: todoModel.todoId,
            projectId: projectId,
            projectName: projectName,
            timePassed: todoModel.timePassed,
          );
        }
      }
    } on FirebaseException catch (error) {
      CustomSnackbars.error(
        error.code,
        error.message!,
      );
    }
  }
}
