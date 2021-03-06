import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/custom_snackbars.dart';
import 'package:todoz_app/core/date_time_formatting.dart';
import '../../core/constants/constants.dart';
import '../../data/models/models.dart';

class TodoProgressiveCard extends StatefulWidget {
  const TodoProgressiveCard({
    Key? key,
    required this.todoModel,
    this.projectColor,
  }) : super(key: key);
  final TodoModel todoModel;
  final Color? projectColor;

  @override
  TodoProgressiveCardState createState() => TodoProgressiveCardState();
}

class TodoProgressiveCardState extends State<TodoProgressiveCard>
    with TickerProviderStateMixin {
  late Timer _timer;
  late Timestamp _duration;
  late Duration _difference;
  late int _timePassed;
  late AnimationController _animationController;
  late ProjectController _projectController;
  late TodoController _todoController;

  @override
  void initState() {
    super.initState();
    _projectController = Get.find<ProjectController>();
    _todoController = Get.find<TodoController>();
    _timePassed = widget.todoModel.timePassed;
    _duration = widget.todoModel.duration!;
    _difference = widget.todoModel.duration!.toDate().difference(
          DateTime(_duration.toDate().year, _duration.toDate().month,
              _duration.toDate().day),
        );
    _timer = Timer(const Duration(seconds: 1), () {});
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeableTile.swipeToTiggerCard(
      swipeThreshold: .2,
      direction: SwipeDirection.horizontal,
      key: Key(widget.todoModel.todoId),
      behavior: HitTestBehavior.translucent,
      backgroundBuilder: (context, direction, _) => _tileBackground(direction),
      color: widget.todoModel.isDone ? Colors.amber : Colors.white,
      borderRadius: 25.0,
      horizontalPadding: 10.0,
      verticalPadding: 10.0,
      onSwiped: (SwipeDirection direction) => _onSwipe(direction),
      shadow: BoxShadow(
        color: Colors.black.withOpacity(.03),
        blurRadius: 10.0,
        offset: const Offset(.0, 10.0),
      ),
      child: _tileForeground(Get.width),
    );
  }

  Widget _tileForeground(double width) {
    return AnimatedContainer(
      constraints: BoxConstraints(
          minHeight: 40, maxHeight: 100, minWidth: 100, maxWidth: width),
      duration: const Duration(milliseconds: 300),
      color: widget.todoModel.isDone ? widget.projectColor : Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.todoModel.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.todoModel.isDone
                      ? AppTextStyles.projectNameProgressive
                          .copyWith(color: Colors.white.withOpacity(0.8))
                      : AppTextStyles.projectNameProgressive,
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: Get.width / 1.65,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: SelectableText(
                      widget.todoModel.content,
                      maxLines: 2,
                      style: widget.todoModel.isDone
                          ? AppTextStyles.todoContentProgressive
                              .copyWith(color: Colors.white)
                          : AppTextStyles.todoContentProgressive,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      DateTimeFormatting.toDoProgressDuration(_duration) +
                          '  |  ',
                      style: widget.todoModel.isDone
                          ? AppTextStyles.timePassedVsDuration
                              .copyWith(color: Colors.white.withOpacity(0.7))
                          : AppTextStyles.timePassedVsDuration,
                    ),
                    Text(
                      DateTimeFormatting.howMuchTimePassed(_timePassed),
                      style: widget.todoModel.isDone
                          ? AppTextStyles.timePassedVsDuration
                              .copyWith(color: Colors.white.withOpacity(0.7))
                          : AppTextStyles.timePassedVsDuration,
                    ),
                    const SizedBox(width: 5.0),
                  ],
                ),
              ],
            ),
            widget.todoModel.isDone
                ? Text(
                    'taskDone'.tr,
                    style: AppTextStyles.textStyleProjectNamePreview,
                  )
                : GestureDetector(
                    onTap: () => _timerOnOff(),
                    child: _percentIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSwipeLeft() {
    if (!widget.todoModel.isDone) {
      return Container(
        padding: const EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.green,
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          EvaIcons.doneAll,
          color: Colors.white,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          EvaIcons.undo,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildBackgroundSwipeRight() {
    return Container(
      padding: const EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.red,
      ),
      alignment: Alignment.centerLeft,
      height: 20,
      width: 20,
      child: const Icon(
        EvaIcons.trash2Outline,
        color: Colors.white,
      ),
    );
  }

  Widget _tileBackground(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.endToStart:
        return _buildBackgroundSwipeLeft();
      case SwipeDirection.startToEnd:
        return _buildBackgroundSwipeRight();
      default:
        return Container();
    }
  }

  CircularPercentIndicator _percentIndicator() {
    return CircularPercentIndicator(
      radius: 75,
      fillColor: Colors.transparent,
      backgroundColor: Colors.black.withOpacity(.05),
      animateFromLastPercent: true,
      animation: true,
      addAutomaticKeepAlive: false,
      circularStrokeCap: CircularStrokeCap.round,
      animationDuration: 500,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (_todoController.timePassedPercent(_duration, _timePassed) == 0 ||
                    _todoController
                            .timePassedPercent(_duration, _timePassed)
                            .isNaN ==
                        true)
                ? 'start'
                : _todoController
                        .timePassedPercent(_duration, _timePassed)
                        .round()
                        .toString() +
                    '%',
            style: AppTextStyles.textStyleBlackSmallText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5.0),
          Container(
            height: 16.0,
            width: 16.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: AppColors.mainPurple.withGreen(0),
            ),
            child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                size: 10,
                color: Colors.white,
                progress: _animationController),
          ),
        ],
      ),
      progressColor: AppColors.mainPurple,
      lineWidth: 4.0,
      percent: _todoController.timePassedPercent(_duration, _timePassed) / 100,
    );
  }

  void _starTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted && _timePassed < _difference.inSeconds) {
          _animationController.forward();
          setState(
            () {
              _timePassed++;
              if (_timePassed == _difference.inSeconds) {
                _stopTimer();
              }
            },
          );
        }
      },
    );
  }

  void _stopTimer() {
    _animationController.reverse();
    _todoController.updateTodo(
      newValue: widget.todoModel.isDone,
      todoId: widget.todoModel.todoId,
      projectId: _projectController.getProjectId(widget.todoModel),
      projectName: widget.todoModel.projectName,
      timePassed: _timePassed,
    );
    _timer.cancel();
  }

  void _timerOnOff() {
    _timer.isActive ? _stopTimer() : _starTimer();
  }

  void _restoreTodo() {
    TodoModel deletedTodo = widget.todoModel.copyWith();
    _todoController.deleteTodo(
      todoId: widget.todoModel.todoId,
      projectId: _projectController.getProjectId(widget.todoModel),
    );
    CustomSnackbars.undoDeleteTodo(
      title: 'deletedSuccessfully'.tr,
      message: 'clickUndo'.tr,
      deletedTodo: deletedTodo,
      projectId: _projectController.getProjectId(deletedTodo),
    );
  }

  void _onSwipe(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.endToStart:
        return _todoController.updateTodo(
          newValue: widget.todoModel.isDone ? false : true,
          todoId: widget.todoModel.todoId,
          projectId: _projectController.getProjectId(widget.todoModel),
          projectName: widget.todoModel.projectName,
          timePassed: widget.todoModel.timePassed,
        );
      case SwipeDirection.startToEnd:
        return _restoreTodo();
      default:
    }
  }
}
