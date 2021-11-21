// ignore_for_file: file_names

import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todoz_app/controllers/todoController.dart';
import 'package:todoz_app/models/todoModel.dart';
import 'package:todoz_app/utils/styles.dart';

class TodayProgress extends StatelessWidget {
  TodayProgress({Key? key}) : super(key: key);
  final dateTime = DateTime.now();

  int get howManyDone {
    TodoController todoController = Get.find<TodoController>();
    List<TodoModel?> listModels = todoController.todos;
    var listDone = [];
    for (var item in listModels) {
      if (item!.isDone == true) {
        listDone.add(item);
      }
    }
    return listDone.length;
  }

  double get percentage {
    TodoController todoController = Get.find<TodoController>();
    int doneTasks = howManyDone;
    int allTasks = todoController.todos.length;

    double result = (doneTasks / allTasks) * 100;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Color(0xFF6E4AFF)),
      height: height / 5,
      width: width,
      child: GetX<TodoController>(
          init: Get.put<TodoController>(TodoController()),
          builder: (TodoController todoController) {
            if (todoController.isBlank != null &&
                todoController.todos.isNotEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'today'.tr + dateTime.format('D, M j'),
                        style: Styles().textStyleWhiteText,
                      ),
                      SizedBox(height: height / 40),
                      Text(
                          'numberOfTasks'.trArgs([
                            howManyDone.toString(),
                            todoController.todos.length.toString()
                          ]),
                          style: Styles().textStyleWhiteBigText)
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 75,
                    fillColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    center: Text(
                      percentage == 0
                          ? 'start NOW'
                          : percentage.toString().substring(0, 4) + '%',
                      style: Styles().textStyleProgress,
                    ),
                    progressColor: Colors.white,
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
                          'today'.tr + dateTime.format('D, M j'),
                          style: Styles().textStyleWhiteText,
                        ),
                        SizedBox(height: height / 40),
                        Text('noTasks'.tr,
                            style: Styles().textStyleWhiteBigText)
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 75,
                      fillColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      center: Text(
                        '0 %',
                        style: Styles().textStyleProgress,
                      ),
                      progressColor: Colors.white,
                      lineWidth: 7.0,
                      percent: percentage / 100,
                    )
                  ]);
            }
          }),
    );
  }
}
