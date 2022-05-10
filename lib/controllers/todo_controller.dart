import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/data/api/firestore_api.dart';
import '../data/models/models.dart';
import '../ui/ui_export.dart';
import 'localization_controller.dart';

class TodoController extends GetxController {
  /// Observable list of [TodoModel]s
  final Rx<List<TodoModel?>> _todoList = Rx<List<TodoModel?>>([]);

  /// Getter for [TodoController]
  List<TodoModel?> get todos => _todoList.value;

  final _firestoreRepository = FirestoreApi();

  late String _uid;

  @override
  onInit() {
    _uid = Get.find<AuthController>().user!.uid;
    _todoList.bindStream(_firestoreRepository.getAllTodos(_uid));
    super.onInit();
  }

  @override
  void onClose() {
    _todoList.close();
    super.onClose();
  }

  /// Creates a new document to store [TodoModel] in [FirebaseFirestore]
  void addTodo({
    required String content,
    required String projectId,
    required String projectName,
    DateTime? dateUntil,
    DateTime? duration,
  }) {
    _firestoreRepository.addTodo(
      content: content,
      uid: _uid,
      projectId: projectId,
      projectName: projectName,
      dateUntil: dateUntil,
      duration: duration,
    );
  }

  void deleteTodo({
    required String todoId,
    required String projectId,
  }) =>
      _firestoreRepository.deleteTodo(
        todoId: todoId,
        uid: _uid,
        projectId: projectId,
      );

  void updateTodo({
    required bool newValue,
    required String todoId,
    required String projectId,
    required String projectName,
    required int timePassed,
  }) {
    _firestoreRepository.updateTodo(
      newValue: newValue,
      uid: _uid,
      todoId: todoId,
      projectId: projectId,
      projectName: projectName,
      timePassed: timePassed,
    );
  }

  /// Returns a list of relevant [TodoModel]'s for ProgressWidget
  List<TodoModel> relevantTodoModels(
    DateTime date,
    int pageIndex,
    bool showAllTodos,
  ) {
    List<TodoModel> retVal = [];
    int tomorrow = date.add(const Duration(days: 1)).day;
    int yesterday = date.subtract(const Duration(days: 1)).day;
    List<int> days = [yesterday, date.day, tomorrow];
    for (var item in todos) {
      bool unshowDoneTasks = !showAllTodos && item!.dateUntil != null;
      int i = 0;
      if (unshowDoneTasks) {
        while (i <= 2) {
          if (pageIndex == i && item.dateUntil!.toDate().day == days[i]) {
            retVal.add(item);
          }
          i++;
        }
      } else {
        retVal.add(item!);
      }
    }
    return retVal;
  }

  /// Returns a list of done/undonde progressive [TodoModel]s
  List<TodoModel> doneUndondeProgressiveTodos(bool showAllTodos) {
    List<TodoModel> retVal = [];
    for (var todo in todos) {
      if (!showAllTodos && todo!.duration != null && !todo.isDone) {
        retVal.add(todo);
      } else if (showAllTodos && todo!.duration != null) {
        retVal.add(todo);
      }
    }
    return retVal;
  }

  /// Returns todos for a specific project
  List<TodoModel> todosInProject(String projectName, bool? done) {
    List<TodoModel> retVal = [];
    for (var todo in todos) {
      if (todo!.projectName == projectName && todo.isDone == done) {
        retVal.add(todo);
      } else if (todo.projectName == projectName && done == null) {
        retVal.add(todo);
      }
    }
    return retVal;
  }

  /// Opens a dialog to create new [TodoModel]
  void openCreateTodo(
    BuildContext context,
    bool visible,
  ) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        children: [
          CreateTodo(
            showAllProjects: visible,
          )
        ],
      ),
    );
  }

  /// Number of all tasks for [ProgressWidget]
  int allTasksLength(
    bool areAllTasks,
    DateTime untilDay,
  ) {
    List<TodoModel> retVal = [];
    for (var item in todos) {
      if (item!.dateUntil != null &&
          item.dateUntil!.toDate().day == untilDay.day &&
          !areAllTasks) {
        retVal.add(item);
      } else if (areAllTasks) {
        retVal.add(item);
      }
    }
    return retVal.length;
  }

  /// Returns number of done tasks in a single project
  int tasksDoneInProjectLength(String projectName) {
    var listModels =
        todos.where((element) => element!.projectName == projectName);
    var listDone = [];
    for (var item in listModels) {
      if (item!.isDone) {
        listDone.add(item);
      }
    }
    return listDone.length;
  }

  /// Returns a number of all tasks in a specific project
  int allTasksInProjectLength(String projetName) {
    return todos.where((element) => element!.projectName == projetName).length;
  }

  /// Returns properly formatted string of how many tasks are done in a specific project
  String allTasksInProjectTitle(String projectName) {
    String _language =
        Get.find<LocalizationController>().currentLocale.languageCode;
    List<String> args = [
      tasksDoneInProjectLength(projectName).toString(),
      allTasksInProjectLength(projectName).toString()
    ];
    return 'numberOfTasks'.trArgs(
      _language != 'zh' ? args : args.reversed.toList(),
    );
  }

  /// Returns properly formatted string of how many tasks are done yesterday/today/tomorrow or all
  String allTasksTitleProgress(bool areAllTasks, DateTime dateTime) {
    String _language =
        Get.find<LocalizationController>().currentLocale.languageCode;
    List<String> args = [
      howManyTasksDoneProgress(dateTime, areAllTasks).toString(),
      allTasksLength(areAllTasks, dateTime).toString(),
    ];
    return 'numberOfTasks'
        .trArgs(_language != 'zh' ? args : args.reversed.toList());
  }

  /// Returns a percentage of done vs. undone tasks in a specific project
  double doneTasksInProjectPercent(String projectName) {
    int doneTasks = tasksDoneInProjectLength(projectName);
    int allTasks =
        todos.where((element) => element!.projectName == projectName).length;
    return doneTasks == 0 ? 0 : (doneTasks / allTasks);
  }

  /// Returns number of done tasks yesterday/today/tomorrow or all
  int howManyTasksDoneProgress(
    DateTime? untilDay,
    bool getAll,
  ) {
    List<TodoModel> retVal = [];
    for (var item in todos) {
      if (item!.dateUntil != null && !getAll) {
        if (item.isDone && item.dateUntil!.toDate().day == untilDay!.day) {
          retVal.add(item);
        }
      } else if (getAll) {
        if (item.isDone) {
          retVal.add(item);
        }
      }
    }
    return retVal.length;
  }

  /// Returns a percentage of done tasks vs. undone tasks yesterday/today/tomorrow or all
  double tasksProgressPercent(DateTime untilDay, bool getAll) {
    int doneTasks = howManyTasksDoneProgress(untilDay, getAll);
    List<TodoModel> retVal = [];
    for (var item in todos) {
      if (item!.dateUntil != null &&
          item.dateUntil!.toDate().day == untilDay.day &&
          !getAll) {
        retVal.add(item);
      } else if (getAll) {
        retVal.add(item);
      }
    }
    int allTasks = retVal.length;
    double result = (doneTasks / allTasks) * 100;
    return result;
  }

  /// Returns percentage of passed time vs. full duration of a task
  double timePassedPercent(Timestamp duration, int timePassed) {
    DateTime _dateDue = duration.toDate();
    Duration _timeUntil = _dateDue
        .difference(DateTime(_dateDue.year, _dateDue.month, _dateDue.day));
    double result = (timePassed / _timeUntil.inSeconds) * 100;
    return result;
  }

  /// Returns number of tasks done on a specific day
  double doneTasksOnDay(DateTime day) {
    return todos
        .where(
          (element) =>
              element!.isDone &&
              element.dateUntil != null &&
              element.dateUntil!.toDate().day == day.day,
        )
        .length
        .toDouble();
  }

  /// Returns time spent on all progressive tasks
  int get allTasksTimeProgressive {
    List<int> models = [];
    int retVal = 0;
    for (var item in todos) {
      if (item!.timePassed > 0) {
        models.add(item.timePassed);
      }
    }
    for (var element in models) {
      retVal += element;
    }
    return retVal;
  }

  /// Returns the highest number of tasks done in last 7 days
  double mostTasksOnDay(DateTime today) {
    List<TodoModel> _sixDaysAgo = [];
    List<TodoModel> _fiveDaysAgo = [];
    List<TodoModel> _fourDaysAgo = [];
    List<TodoModel> _threeDaysAgo = [];
    List<TodoModel> _beforeYesterday = [];
    List<TodoModel> _yesterday = [];
    List<TodoModel> _today = [];
    List<List<TodoModel>> listOfLists = [
      _today,
      _yesterday,
      _beforeYesterday,
      _threeDaysAgo,
      _fourDaysAgo,
      _fiveDaysAgo,
      _sixDaysAgo,
    ];

    for (TodoModel? item in todos) {
      bool doneTaskHasDate = item!.isDone && item.dateUntil != null;
      int i = 0;
      DateTime day = today;
      if (doneTaskHasDate) {
        while (i <= 6) {
          if (item.dateUntil!.toDate().day == day.day) {
            listOfLists[i].add(item);
          }
          day = day.subtract(Duration(days: i));
          i++;
        }
      }
    }
    listOfLists.sort((a, b) => a.length.compareTo(b.length));
    return listOfLists.last.length.toDouble();
  }
}
