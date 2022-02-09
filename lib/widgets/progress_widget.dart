import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/utils/styles.dart';

class ProgressWidget extends StatefulWidget {
  const ProgressWidget(
      {Key? key,
      required this.dateTime,
      required this.day,
      required this.areAllTasks})
      : super(key: key);
  final DateTime dateTime;
  final String day;
  final bool areAllTasks;

  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  /// Formatting date to be more readable
  String get dateText {
    String dateText = '';
    if (widget.areAllTasks == false) {
      dateText = widget.day.tr + widget.dateTime.format('j.m Y');
    } else {
      dateText = 'allTasks'.tr;
    }
    return dateText;
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color(0xFF6E4AFF)),
        height: height / 5,
        width: width,
        child: GetX<TodoController>(
            init: Get.put<TodoController>(TodoController()),
            builder: (TodoController todoController) {
              var percentage = todoController.percentageOfTasks(
                  widget.dateTime, widget.areAllTasks);
              var howManyDone = todoController.howManyTasksDone(
                  widget.dateTime, widget.areAllTasks);
              if (todoController.todos.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dateText,
                          style: Styles.textStyleWhiteText,
                        ),
                        SizedBox(height: height / 40),
                        Text(
                            percentage.isNaN == false
                                ? 'numberOfTasks'.trArgs([
                                    howManyDone.toString(),
                                    todoController
                                        .numberOfAllTasks(
                                            widget.areAllTasks, widget.dateTime)
                                        .toString()
                                  ])
                                : 'noTasks'.tr,
                            style: Styles.doneVsUndoneProgressWidget),
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 80,
                      fillColor: Colors.transparent,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      animateFromLastPercent: true,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      animationDuration: 500,
                      center: Text(
                        (percentage == 0 || percentage.isNaN == true)
                            ? '0% :('
                            : (percentage == 100)
                                ? '100%'
                                : percentage.toString().substring(0, 4) + '%',
                        style: Styles.textStyleProgress,
                      ),
                      progressColor: const Color(0xFF5430E5),
                      lineWidth: 7.0,
                      percent: percentage / 100,
                    )
                  ],
                );
              } else {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.day.tr + widget.dateTime.format('j.m Y'),
                            style: Styles.textStyleWhiteText,
                          ),
                          SizedBox(height: height / 40),
                          Text('noTasks'.tr,
                              style: Styles.doneVsUndoneProgressWidget)
                        ],
                      ),
                    ]);
              }
            }),
      ),
    );
  }
}
