import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> addTodo(
      {@required String? content, @required String? uid}) async {
    try {
      await _firestore.collection('users').doc(uid).collection('todos').add({
        'dateCreated': Timestamp.now(),
        'content': content,
        'isDone': false
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<TodoModel>> getTodos(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('todos')
        .orderBy('isDone', descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<TodoModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(TodoModel.fromDocumentSnapshot(element));
      }
      return retVal;
    });
  }

  Future<void> updateTodo(bool newValue, String uid, String todoID) async {
    try {
      _firestore
          .collection('users')
          .doc(uid)
          .collection('todos')
          .doc(todoID)
          .update({'isDone': newValue});
    } catch (e) {
      print(e);
    }
  }
}
