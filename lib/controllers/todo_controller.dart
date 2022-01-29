import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/widgets/create_todo_widget.dart';
import 'package:date_time_format/src/date_time_extension_methods.dart';

class TodoController extends GetxController {
  final Rx<List<TodoModel?>> _todoList = Rx<List<TodoModel?>>([]);

  List<TodoModel?> get todos => _todoList.value;

  @override
  onInit() {
    String uid = Get.find<AuthController>().user!.uid;
    _todoList.bindStream(Database().getAllTodos(uid));
    super.onInit();
  }

  List<TodoModel> relevantTodoModels(TodoController todoController,
      DateTime _date, int _pageIndex, bool _showAllTodos) {
    List<TodoModel?> models = todoController.todos;
    List<TodoModel> retVal = [];
    int yesterday = _date.subtract(const Duration(days: 1)).day;
    int tomorrow = _date.add(const Duration(days: 1)).day;
    for (var item in models) {
      if (_pageIndex == 0 &&
          item!.dateUntil != null &&
          item.dateUntil!.toDate().day == yesterday &&
          _showAllTodos == false) {
        retVal.add(item);
      } else if (_pageIndex == 1 &&
          item!.dateUntil != null &&
          item.dateUntil!.toDate().day == _date.day &&
          _showAllTodos == false) {
        retVal.add(item);
      } else if (_pageIndex == 2 &&
          item!.dateUntil != null &&
          item.dateUntil!.toDate().day == tomorrow &&
          _showAllTodos == false) {
        retVal.add(item);
      } else if (_showAllTodos == true) {
        retVal.add(item!);
      }
    }
    return retVal;
  }

  void addTodo({
    required String projectName,
    required TextEditingController controller,
    required String uid,
    String? projectId,
    DateTime? dateUntil,
    DateTime? duration,
  }) {
    if (controller.text != "") {
      Database().addTodo(
          projectId: projectId,
          projectName: projectName == '' ? 'NoProject' : projectName,
          content: controller.text,
          dateUntil: dateUntil,
          duration: duration,
          uid: uid);

      controller.clear();
    } else {
      Get.snackbar('Error', 'Error 2', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void openCreateTodo(
      BuildContext context, bool visible, ProjectModel? projectModel) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              children: [
                CreateTodo(visibility: visible, projectModel: projectModel)
              ],
            ));
  }

  String countUntilTime(Timestamp due) {
    String outputDate;
    DateTime dateDue = due.toDate();
    Duration _timeUntil = dateDue.difference(DateTime.now());
    int _daysUntil = _timeUntil.inDays;
    int _hoursUntil = _timeUntil.inHours - (_daysUntil * 24);
    int _minUntil =
        _timeUntil.inMinutes - (_daysUntil * 24 * 60) - (_hoursUntil * 60);

    if (_daysUntil > 0) {
      outputDate = _daysUntil.toString() +
          "days".tr +
          _hoursUntil.toString() +
          "hours".tr;
    } else if (_hoursUntil > 0) {
      outputDate = _hoursUntil.toString() +
          "hours".tr +
          _minUntil.toString() +
          "minutes".tr;
    } else if (_minUntil > 0) {
      outputDate = _minUntil.toString() + "minutes".tr;
    } else {
      outputDate = 'till'.tr + dateDue.format('j.m.Y, h:i');
    }
    return outputDate;
  }

  String toDoProgressDuration(Timestamp duration) {
    String outputDate = '';
    DateTime dateDue = duration.toDate();
    Duration _timeUntil =
        dateDue.difference(DateTime(dateDue.year, dateDue.month, dateDue.day));
    int _daysUntil = _timeUntil.inDays;
    int _hoursUntil = _timeUntil.inHours - (_daysUntil * 24);
    int _minUntil =
        _timeUntil.inMinutes - (_daysUntil * 24 * 60) - (_hoursUntil * 60);
    int _secUntil = _timeUntil.inSeconds - (_minUntil * 60);
    String s = _secUntil.toString().length <= 2
        ? _secUntil.toString()
        : _secUntil.toString().substring(_secUntil.toString().length - 2);

    if (_daysUntil > 0) {
      outputDate = _daysUntil.toString() +
          "days".tr +
          _hoursUntil.toString() +
          "hours".tr;
    } else if (_hoursUntil > 0) {
      outputDate = _hoursUntil.toString() +
          "hours".tr +
          _minUntil.toString() +
          "minutes".tr;
    } else if (_minUntil > 0) {
      outputDate = _minUntil.toString() + "minutes".tr;
    } else if (_secUntil > 0) {
      outputDate = s.toString() + "seconds".tr;
    }
    return outputDate;
  }

  List howManyTaskDone(
      TodoController todoController, DateTime untilDay, bool getAll) {
    List<TodoModel?> listModels = todoController.todos;
    var listDone = [];
    for (var item in listModels) {
      if (item!.dateUntil != null && getAll == false) {
        if (item.isDone == true &&
            item.dateUntil!.toDate().day == untilDay.day) {
          listDone.add(item);
        }
      } else if (getAll == true) {
        if (item.isDone == true) {
          listDone.add(item);
        }
      }
    }
    return listDone;
  }

  String howMuchTimePassed(int seconds) {
    String _timePassed = '';
    int _hour = (seconds ~/ 3600).toInt();
    int _minute = (seconds ~/ 60).toInt();
    if (_hour >= 0) {
      _timePassed = _hour.toString() +
          'hours'.tr +
          (_minute % 60).toString() +
          'minutes'.tr +
          (seconds % 60).toString() +
          'seconds'.tr;
    }
    return _timePassed;
  }

  double percentageOfTasks(
      TodoController todoController, DateTime untilDay, bool getAll) {
    int doneTasks = howManyTaskDone(todoController, untilDay, getAll).length;
    List<TodoModel?> listModels = todoController.todos;
    var listAll = [];
    for (var item in listModels) {
      if (item!.dateUntil != null &&
          item.dateUntil!.toDate().day == untilDay.day &&
          getAll == false) {
        listAll.add(item);
      } else if (getAll == true) {
        listAll.add(item);
      }
    }
    int allTasks = listAll.length;
    double result = (doneTasks / allTasks) * 100;
    return result;
  }

  double percentageOfTimePassed(Timestamp duration, int timePassed) {
    DateTime _dateDue = duration.toDate();
    Duration _timeUntil = _dateDue
        .difference(DateTime(_dateDue.year, _dateDue.month, _dateDue.day));
    double result = (timePassed / _timeUntil.inSeconds) * 100;
    return result;
  }
}
