import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/date_time_formatting.dart';
import '../../core/constants/constants.dart';

class ProductivityPage extends GetWidget<TodoController> {
  ProductivityPage({Key? key}) : super(key: key);
  static const List<Color> _gradientColors = [
    Colors.white,
    AppColors.mainPurple,
  ];
  final _projectController = Get.find<ProjectController>();

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

  List<LineTooltipItem> _getToolTipItems(List<LineBarSpot> touchedSpots) {
    List<LineTooltipItem> _items = [];
    for (var item in touchedSpots) {
      LineTooltipItem itemm = LineTooltipItem(
        '${item.y.toInt().toString()} ',
        AppTextStyles.whiteTitleNormal.copyWith(fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: _tasksPluralLabel(item.y.toInt()) + '\n',
              style: AppTextStyles.whiteTitleNormal),
          TextSpan(
              text: DateTimeFormatting.dayOfTheWeek(item.x.toInt()),
              style: AppTextStyles.whiteTitleNormal),
        ],
      );
      _items.add(itemm);
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.accentPurple,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                'productivityPage'.tr,
                style: AppTextStyles.textStyleTitle,
              ),
            ),
            const SizedBox(height: 20.0),
            Obx(
              () => Center(
                child: Text(
                    _congrats(
                      controller.mostTasksOnDay(DateTimeFormatting.today),
                    ),
                    style: AppTextStyles.giantTitle),
              ),
            ),
            Obx(
              () => Center(
                child: Text(
                  DateTimeFormatting.howMuchTimePassed(
                          controller.allTasksTimeProgressive) +
                      'timeSpent'.tr,
                  style: AppTextStyles.dateTimeItem,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            _tasksProjectsWidgets(),
            const SizedBox(height: 10.0),
            _lineChart()
          ],
        ),
      ),
    );
  }

  Widget _lineChart() {
    return Expanded(
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
                maxY: controller
                    .mostTasksOnDay(DateTimeFormatting.today)
                    .truncateToDouble(),
                minY: -0.2,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 20.0,
                    getTooltipItems: _getToolTipItems,
                    tooltipMargin: 10.0,
                    tooltipPadding: const EdgeInsets.all(10.0),
                    tooltipBgColor: AppColors.mainPurple,
                    fitInsideHorizontally: true,
                  ),
                  enabled: true,
                ),
                lineBarsData: [_lineChartBarData()]),
          ),
        ),
      ),
    );
  }

  Widget _tasksProjectsWidgets() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => NumberOfTasks(
              controller: controller,
              text: _tasksPluralLabel(
                  controller.todos.where((element) => element!.isDone).length),
            ),
          ),
          Obx(
            () => NumberOfProjects(
              controller: _projectController,
              func: _projectsPluralLabel(_projectController.projects.length),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _lineChartBarData() {
    return LineChartBarData(
      dotData: FlDotData(show: true),
      isStrokeCapRound: true,
      curveSmoothness: .3,
      preventCurveOverShooting: true,
      isCurved: true,
      colors: _gradientColors,
      barWidth: .0,
      belowBarData: BarAreaData(
          show: true,
          colors:
              _gradientColors.map((color) => color.withOpacity(0.2)).toList()),
      spots: [
        FlSpot(
          0,
          controller.doneTasksOnDay(DateTimeFormatting.sixDaysBefore),
        ),
        FlSpot(
          1,
          controller.doneTasksOnDay(DateTimeFormatting.fiveDaysBefore),
        ),
        FlSpot(
          2,
          controller.doneTasksOnDay(DateTimeFormatting.fourDaysBefore),
        ),
        FlSpot(
          3,
          controller.doneTasksOnDay(DateTimeFormatting.threeDaysBefore),
        ),
        FlSpot(
          4,
          controller.doneTasksOnDay(DateTimeFormatting.beforeYesterday),
        ),
        FlSpot(
          5,
          controller.doneTasksOnDay(DateTimeFormatting.yesterday),
        ),
        FlSpot(
          6,
          controller.doneTasksOnDay(DateTimeFormatting.today),
        ),
      ],
    );
  }
}

class NumberOfTasks extends StatelessWidget {
  const NumberOfTasks({
    Key? key,
    required this.controller,
    required this.text,
  }) : super(key: key);

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
                .where((element) => element!.isDone)
                .length
                .toString(),
            style: AppTextStyles.numberOfTasksProductivity,
          ),
          Text(
            text,
            style: AppTextStyles.numberOfTasksLabelProductivity,
          ),
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
          color: AppColors.mainPurple),
    );
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
        color: AppColors.mainRed,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            controller.projects.length.toString(),
            style: AppTextStyles.numberOfTasksProductivity,
          ),
          Text(
            func,
            style: AppTextStyles.numberOfTasksLabelProductivity,
          ),
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
