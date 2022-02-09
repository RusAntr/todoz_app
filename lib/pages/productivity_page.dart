import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/utils/styles.dart';

class ProductivityPage extends GetWidget<TodoController> {
  const ProductivityPage({Key? key}) : super(key: key);
  static final List<Color> _gradientColors = [
    Colors.white,
    const Color(0xff6E4AFF),
  ];

  double tasksDoneOnDay(DateTime day) {
    return controller.todos
        .where((element) =>
            element!.isDone == true &&
            element.dateUntil != null &&
            element.dateUntil!.toDate().day == day.day)
        .length
        .toDouble();
  }

  int get _timeOfAllTasks {
    List<int> suitModels = [];
    int retVal = 0;
    for (var item in controller.todos) {
      if (item!.timePassed > 0) {
        suitModels.add(item.timePassed);
      }
    }
    for (var element in suitModels) {
      retVal += element;
    }
    return retVal;
  }

  double _mostTasksOnDay(DateTime today) {
    List<TodoModel> _sixDaysAgo = [];
    List<TodoModel> _fiveDaysAgo = [];
    List<TodoModel> _fourDaysAgo = [];
    List<TodoModel> _threeDaysAgo = [];
    List<TodoModel> _beforeYesterday = [];
    List<TodoModel> _yesterday = [];
    List<TodoModel> _today = [];

    for (var item in controller.todos) {
      if (item!.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day == today.day) {
        _today.add(item);
      } else if (item.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day ==
              today.subtract(const Duration(days: 1)).day) {
        _yesterday.add(item);
      } else if (item.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day ==
              today.subtract(const Duration(days: 2)).day) {
        _beforeYesterday.add(item);
      } else if (item.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day ==
              today.subtract(const Duration(days: 3)).day) {
        _threeDaysAgo.add(item);
      } else if (item.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day ==
              today.subtract(const Duration(days: 4)).day) {
        _fourDaysAgo.add(item);
      } else if (item.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day ==
              today.subtract(const Duration(days: 5)).day) {
        _fiveDaysAgo.add(item);
      } else if (item.isDone == true &&
          item.dateUntil != null &&
          item.dateUntil!.toDate().day ==
              today.subtract(const Duration(days: 6)).day) {
        _sixDaysAgo.add(item);
      }
    }
    List<int> _listOFLists = [
      _today.length,
      _yesterday.length,
      _beforeYesterday.length,
      _threeDaysAgo.length,
      _fourDaysAgo.length,
      _fiveDaysAgo.length,
      _sixDaysAgo.length
    ];
    _listOFLists.sort();
    return _listOFLists.last.toDouble();
  }

  String _tasksPluralLabel(int numberOfTasks) {
    numberOfTasks = numberOfTasks % 100;

    if (numberOfTasks >= 11 && numberOfTasks <= 19) {
      return 'tasksPlural'.tr;
    } else {
      int i = numberOfTasks % 10;
      switch (i) {
        case 1:
          return 'tasksPlural1'.tr;
        case 2:
        case 3:
        case 4:
          return 'tasksPlural234'.tr;
      }
    }
    return 'tasksPlural'.tr;
  }

  String _projectsPluralLabel(int numberOfProjects) {
    numberOfProjects = numberOfProjects % 100;
    if (numberOfProjects >= 11 && numberOfProjects <= 19) {
      return 'projectsPlural'.tr;
    } else {
      int i = numberOfProjects % 10;
      switch (i) {
        case 1:
          return 'projectsPlural1'.tr;
        case 2:
        case 3:
        case 4:
          return 'projectsPlural234'.tr;
      }
    }
    return 'projectsPlural'.tr;
  }

  String _congrats(double tasksDoneThisWeek) {
    if (tasksDoneThisWeek == 0) {
      return 'nothing'.tr;
    } else if (tasksDoneThisWeek <= 2) {
      return 'notBad'.tr;
    } else if (tasksDoneThisWeek <= 5) {
      return 'good'.tr;
    } else if (tasksDoneThisWeek <= 8) {
      return 'amazing'.tr;
    } else if (tasksDoneThisWeek <= 10) {
      return 'fantastic'.tr;
    }
    return 'fantastic'.tr;
  }

  @override
  Widget build(BuildContext context) {
    final ProjectController _projectController = Get.find<ProjectController>();
    DateTime _today = DateTime.now();
    DateTime _yesterday = _today.subtract(const Duration(days: 1));
    DateTime _beforeYesterday = _today.subtract(const Duration(days: 2));
    DateTime _threeDaysBefore = _today.subtract(const Duration(days: 3));
    DateTime _fourDaysBefore = _today.subtract(const Duration(days: 4));
    DateTime _fiveDaysBefore = _today.subtract(const Duration(days: 5));
    DateTime _sixDaysBefore = _today.subtract(const Duration(days: 6));
    return Scaffold(
      backgroundColor: const Color(0xffC4B5FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20),
            child: Text('productivityPage'.tr, style: Styles.textStyleTitle),
          ),
          const SizedBox(height: 20.0),
          Obx(() => Center(
                child: Text(_congrats(_mostTasksOnDay(_today)),
                    style: Styles.giantTitle),
              )),
          Obx(() => Center(
                  child: Text(
                controller.howMuchTimePassed(_timeOfAllTasks) + 'timeSpent'.tr,
                style: Styles.dateTimeItem,
              ))),
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => NumberOfTasks(
                      controller: controller,
                      text: _tasksPluralLabel(controller.todos
                          .where((element) => element!.isDone == true)
                          .length),
                    )),
                Obx(() => NumberOfProjects(
                      controller: _projectController,
                      func: _projectsPluralLabel(
                          _projectController.projects.length),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LineChart(
                  LineChartData(
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      minX: 0,
                      maxX: 6.0,
                      maxY: _mostTasksOnDay(_today),
                      minY: -0.2,
                      lineBarsData: [
                        LineChartBarData(
                            show: true,
                            dotData: FlDotData(show: true),
                            isStrokeCapRound: true,
                            curveSmoothness: .3,
                            preventCurveOverShooting: true,
                            isCurved: true,
                            colors: _gradientColors,
                            barWidth: .0,
                            belowBarData: BarAreaData(
                                show: true,
                                colors: _gradientColors
                                    .map((color) => color.withOpacity(0.2))
                                    .toList()),
                            spots: [
                              FlSpot(0, tasksDoneOnDay(_sixDaysBefore)),
                              FlSpot(1, tasksDoneOnDay(_fiveDaysBefore)),
                              FlSpot(2, tasksDoneOnDay(_fourDaysBefore)),
                              FlSpot(3, tasksDoneOnDay(_threeDaysBefore)),
                              FlSpot(4, tasksDoneOnDay(_beforeYesterday)),
                              FlSpot(5, tasksDoneOnDay(_yesterday)),
                              FlSpot(6, tasksDoneOnDay(_today)),
                            ]),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NumberOfTasks extends StatelessWidget {
  const NumberOfTasks({Key? key, required this.controller, required this.text})
      : super(key: key);

  final TodoController controller;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        width: 85.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                controller.todos
                    .where((element) => element!.isDone == true)
                    .length
                    .toString(),
                style: Styles.numberOfTasksProductivity),
            Text(text, style: Styles.numberOfTasksLabelProductivity),
            const SizedBox(height: 5.0),
            const Icon(
              Icons.assignment_turned_in,
              color: Colors.white,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: const Color(0xff6E4AFF)));
  }
}

class NumberOfProjects extends StatelessWidget {
  const NumberOfProjects({
    Key? key,
    required this.func,
    required this.controller,
  }) : super(key: key);

  final ProjectController controller;
  final String func;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 85.0,
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: const Color(0xffE56363)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(controller.projects.length.toString(),
              style: Styles.numberOfTasksProductivity),
          Text(func, style: Styles.numberOfTasksLabelProductivity),
          const SizedBox(height: 5.0),
          const Icon(
            Icons.folder,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
