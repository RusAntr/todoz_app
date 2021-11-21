// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:todoz_app/controllers/authController.dart';
import 'package:todoz_app/models/todoModel.dart';
import 'package:todoz_app/services/database.dart';

class TodoController extends GetxController {
  final Rx<List<TodoModel?>> _todoList = Rx<List<TodoModel?>>([]);

  List<TodoModel?> get todos => _todoList.value;

  @override
  onInit() {
    String uid = Get.find<AuthController>().user!.uid;
    _todoList.bindStream(Database().getTodos(uid));
    super.onInit();
  }
}
