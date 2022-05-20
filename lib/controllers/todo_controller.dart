import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/data/api/firestore_api.dart';
import '../data/models/models.dart';
import '../ui/ui_export.dart';
import 'localization_controller.dart';

enum TodoSortType {
  byDateCreated,
  byDateUntil,
  byDuration,
  byTimePassed,
}

class TodoController extends GetxController {
  /// Observable list of [TodoModel]s
  final Rx<List<TodoModel?>> _todoList = Rx<List<TodoModel?>>([]);

  final _firestoreRepository = FirestoreApi();

  late String _uid;

  /// Sorts [TodoModel]s in the observable [_todoList]
  void sort(TodoSortType type, bool ascending) {
    _todoList.value.sort((a, b) {
      switch (type) {
        case TodoSortType.byDateCreated:
          return ascending
              ? b!.dateCreated.compareTo(a!.dateCreated)
              : a!.dateCreated.compareTo(b!.dateCreated);
        case TodoSortType.byDateUntil:
          var aa = a?.dateUntil ?? Timestamp(0, 0);
          var bb = b?.dateUntil ?? Timestamp(0, 0);
          return ascending ? bb.compareTo(aa) : aa.compareTo(bb);
        case TodoSortType.byDuration:
          DateTime aDue = a?.duration?.toDate() ?? DateTime(0);
          DateTime bDue = b?.duration?.toDate() ?? DateTime(0);
          Duration aUntil = aDue.difference(
            DateTime(aDue.year, aDue.month, aDue.day),
          );
          Duration bUntil = bDue.difference(
            DateTime(bDue.year, bDue.month, bDue.day),
          );
          return ascending
              ? bUntil.compareTo(aUntil)
              : aUntil.compareTo(bUntil);
        case TodoSortType.byTimePassed:
          return ascending
              ? b!.timePassed.compareTo(a!.timePassed)
              : a!.timePassed.compareTo(b!.timePassed);
        default:
          return ascending
              ? b!.dateCreated.compareTo(a!.dateCreated)
              : a!.dateCreated.compareTo(b!.dateCreated);
      }
    });
  }

  /// Returns a sorted list of [TodoModel]'s
  List<TodoModel?> get todos => _todoList.value;

  /// Return a list of all [TodoModel]s that are done
  List<TodoModel?> get doneTodos =>
      _todoList.value.where((element) => element!.isDone).toList();

  List<TodoModel?> searchTodos(String searchText) {
    List<TodoModel?> _foundTodos = [];
    if (searchText.isNotEmpty) {
      _foundTodos = doneTodos
          .where(
              (element) => element!.content.toLowerCase().contains(searchText))
          .toList();
    } else {
      _foundTodos = doneTodos;
    }
    return _foundTodos;
  }

  @override
  onInit() {
    _uid = Get.find<AuthController>().user!.uid;
    _todoList.bindStream(
      _firestoreRepository.getAllTodos(uid: _uid),
    );
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
      bool unshowAllTasks = !showAllTodos && item!.dateUntil != null;
      int i = 0;
      if (unshowAllTasks) {
        while (i <= 2) {
          if (pageIndex == i && item.dateUntil!.toDate().day == days[i]) {
            retVal.add(item);
          }
          i++;
        }
      } else if (showAllTodos) {
        retVal.add(item!);
      }
    }
    return retVal;
  }

  /// Returns a list of done/undonde progressive [TodoModel]s
  List<TodoModel> doneUndondeProgressiveTodos(
      bool showAllTodos, int pageIndex, DateTime date) {
    return relevantTodoModels(date, pageIndex, showAllTodos)
        .where((element) => element.duration != null && !element.isDone)
        .toList();
  }

  /// Returns [TodoModel]s for a specific project
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
  void openCreateTodo({
    required BuildContext context,
    required bool visible,
    ProjectModel? projectModel,
  }) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        children: [
          CreateTodo(
            showAllProjects: visible,
            projectModel: projectModel,
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

  /// Sorts all [TodoModel]s that are done & have a deadline. Returns the highest number of tasks
  /// done in last 7 days which will be the maximum of a Y axis on a productivity chart
  double mostTasksOnDay() {
    List<List<TodoModel>> listOfLists = [[], [], [], [], [], [], []];
    for (TodoModel? item in doneTodos) {
      bool doneTaskHasDate = item!.dateUntil != null;
      int i = 0;
      DateTime today = DateTime.now();
      if (doneTaskHasDate) {
        while (i <= 6) {
          if (item.dateUntil!.toDate().day == today.day) {
            listOfLists[i].add(item);
          }
          today = today.subtract(const Duration(days: 1));
          i++;
        }
      }
    }
    listOfLists.sort((a, b) => a.length.compareTo(b.length));
    return listOfLists.last.length.toDouble();
  }
}
