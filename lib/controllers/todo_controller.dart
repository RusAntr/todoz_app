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
    String _uid = Get.find<AuthController>().user!.uid;
    _todoList.bindStream(Database().getAllTodos(_uid));
    super.onInit();
  }

  void clear() {
    _todoList.value = [];
  }

  /// A list of [TodoModel]'s for [TodoCard]
  List<TodoModel> relevantTodoModels(
      DateTime _date, int _pageIndex, bool _showAllTodos) {
    List<TodoModel> retVal = [];
    int yesterday = _date.subtract(const Duration(days: 1)).day;
    int tomorrow = _date.add(const Duration(days: 1)).day;
    for (var item in todos) {
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

  /// Adds new [TodoModel] to [Firestore]'s database
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
          projectName: projectName,
          content: controller.text,
          dateUntil: dateUntil,
          duration: duration,
          uid: uid);

      controller.clear();
    } else {
      Get.snackbar('Error', 'Error 2', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Opening a dialog to create new [TodoModel]
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

  /// Counting and formatting date until tasks needs to be done for [TodoCard]
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

  /// Number of all tasks for [ProgressWidget]
  int numberOfAllTasks(bool areAllTasks, DateTime untilDay) {
    List<TodoModel> retVal = [];
    for (var item in todos) {
      if (item!.dateUntil != null &&
          item.dateUntil!.toDate().day == untilDay.day &&
          areAllTasks == false) {
        retVal.add(item);
      } else if (areAllTasks == true) {
        retVal.add(item);
      }
    }
    return retVal.length;
  }

  /// Formatting duration time setted for a task
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

  /// Number of done tasks
  int howManyTasksDone(DateTime? untilDay, bool getAll) {
    List<TodoModel> retVal = [];
    for (var item in todos) {
      if (item!.dateUntil != null && getAll == false) {
        if (item.isDone == true &&
            item.dateUntil!.toDate().day == untilDay!.day) {
          retVal.add(item);
        }
      } else if (getAll == true) {
        if (item.isDone == true) {
          retVal.add(item);
        }
      }
    }
    return retVal.length;
  }

  /// Formatting seconds to minutes & hours
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

  /// Counting percentage of done tasks vs. undone tasks for [ProgressWidget]
  double percentageOfTasks(DateTime untilDay, bool getAll) {
    int doneTasks = howManyTasksDone(untilDay, getAll);
    List<TodoModel> retVal = [];
    for (var item in todos) {
      if (item!.dateUntil != null &&
          item.dateUntil!.toDate().day == untilDay.day &&
          getAll == false) {
        retVal.add(item);
      } else if (getAll == true) {
        retVal.add(item);
      }
    }
    int allTasks = retVal.length;
    double result = (doneTasks / allTasks) * 100;
    return result;
  }

  /// Counting percentage of passed time vs full duration of a task for [TodoProgressiveWidget]
  double percentageOfTimePassed(Timestamp duration, int timePassed) {
    DateTime _dateDue = duration.toDate();
    Duration _timeUntil = _dateDue
        .difference(DateTime(_dateDue.year, _dateDue.month, _dateDue.day));
    double result = (timePassed / _timeUntil.inSeconds) * 100;
    return result;
  }
}
