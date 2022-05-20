import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/date_time_formatting.dart';
import '../../core/constants/constants.dart';

class ProgressWidget extends StatefulWidget {
  const ProgressWidget({
    Key? key,
    required this.dateTime,
    required this.day,
    required this.areAllTasks,
  }) : super(key: key);
  final DateTime dateTime;
  final String day;
  final bool areAllTasks;

  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColors.mainPurple,
        ),
        height: Get.height / 5,
        width: Get.width,
        child: GetX<TodoController>(
          builder: (TodoController todoController) {
            double percentage = todoController.tasksProgressPercent(
                widget.dateTime, widget.areAllTasks);
            int howManyDone = todoController.howManyTasksDoneProgress(
                widget.dateTime, widget.areAllTasks);
            if (todoController.todos.isNotEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _numberOfTasks(percentage, howManyDone, todoController),
                  _progressIndicator(percentage),
                ],
              );
            } else {
              return _date();
            }
          },
        ),
      ),
    );
  }

  Widget _date() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTimeFormatting.dateText(
                false,
                widget.day,
                widget.dateTime,
              ),
              style: AppTextStyles.textStyleWhiteText,
            ),
            const SizedBox(height: 20),
            Text(
              'noTasks'.tr,
              style: AppTextStyles.doneVsUndoneProgressWidget,
            )
          ],
        ),
      ],
    );
  }

  CircularPercentIndicator _progressIndicator(double percentage) {
    percentage.isNaN ? percentage = 0 : percentage;
    return CircularPercentIndicator(
      radius: 80,
      fillColor: Colors.transparent,
      backgroundColor: Colors.white.withOpacity(0.3),
      animateFromLastPercent: true,
      animation: true,
      circularStrokeCap: CircularStrokeCap.round,
      animationDuration: 500,
      center: Text(
        percentage == 0
            ? '0% :('
            : (percentage == 100)
                ? '100%'
                : percentage.toStringAsFixed(2) + '%',
        style: AppTextStyles.textStyleProgress,
      ),
      progressColor: AppColors.darkPurple,
      lineWidth: 7.0,
      percent: percentage / 100,
    );
  }

  Widget _numberOfTasks(
    double percentage,
    int howManyDone,
    TodoController todoController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateTimeFormatting.dateText(
            widget.areAllTasks,
            widget.day,
            widget.dateTime,
          ),
          style: AppTextStyles.textStyleWhiteText,
        ),
        const SizedBox(height: 20),
        Text(
          !percentage.isNaN
              ? todoController.allTasksTitleProgress(
                  widget.areAllTasks, widget.dateTime)
              : 'noTasks'.tr,
          style: AppTextStyles.doneVsUndoneProgressWidget,
        )
      ],
    );
  }
}
