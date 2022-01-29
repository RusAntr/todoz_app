import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';

class TodoProgressiveWidget extends StatefulWidget {
  const TodoProgressiveWidget({
    Key? key,
    required this.uid,
    required this.todoModel,
  }) : super(key: key);
  final String uid;
  final TodoModel todoModel;

  @override
  TodoProgressiveWidgetState createState() => TodoProgressiveWidgetState();
}

class TodoProgressiveWidgetState extends State<TodoProgressiveWidget>
    with TickerProviderStateMixin {
  late Timer _timer;
  late Timestamp _duration;
  late Duration _difference;
  late int _timePassed;
  late AnimationController _animationController;

  void starTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _timePassed < _difference.inSeconds) {
        _animationController.forward();
        setState(() {
          _timePassed++;
          if (_timePassed == _difference.inSeconds) {
            stopTimer();
          }
        });
      }
    });
  }

  void stopTimer() {
    _animationController.reverse();
    Database().updateTodo(
        widget.todoModel.isDone,
        widget.uid,
        widget.todoModel.todoId,
        ProjectController().getProjectId(widget.todoModel),
        widget.todoModel.projectName,
        _timePassed);
    _timer.cancel();
  }

  void timerOnOff() {
    if (_timer.isActive == false) {
      starTimer();
    } else {
      stopTimer();
    }
  }

  void onSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.endToStart) {
      Database().updateTodo(
          true,
          widget.uid,
          widget.todoModel.todoId,
          ProjectController().getProjectId(widget.todoModel),
          widget.todoModel.projectName,
          widget.todoModel.timePassed);
    } else if (direction == SwipeDirection.startToEnd) {
      Database().deleteTodo(widget.todoModel.todoId, widget.uid,
          ProjectController().getProjectId(widget.todoModel));
    }
  }

  @override
  void initState() {
    super.initState();
    _timePassed = widget.todoModel.timePassed;
    _duration = widget.todoModel.duration!;
    _difference = widget.todoModel.duration!.toDate().difference(DateTime(
        _duration.toDate().year,
        _duration.toDate().month,
        _duration.toDate().day));
    _timer = Timer(const Duration(seconds: 1), () {});
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    stopTimer();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeableTile.swipeToTiggerCard(
      swipeThreshold: 0.2,
      direction: SwipeDirection.horizontal,
      key: Key(widget.todoModel.todoId),
      behavior: HitTestBehavior.opaque,
      backgroundBuilder: (context, direction, _) {
        if (direction == SwipeDirection.endToStart) {
          return Container(
              padding: const EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.green,
              ),
              alignment: Alignment.centerRight,
              child: const Icon(EvaIcons.doneAll, color: Colors.white));
        } else if (direction == SwipeDirection.startToEnd) {
          return Container(
              padding: const EdgeInsets.only(left: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.red,
              ),
              alignment: Alignment.centerLeft,
              height: 20,
              width: 20,
              child: const Icon(EvaIcons.trash2Outline, color: Colors.white));
        }
        return Container();
      },
      color: Colors.white,
      borderRadius: 25,
      horizontalPadding: 15,
      verticalPadding: 10,
      onSwiped: (SwipeDirection direction) {
        onSwipe(direction);
      },
      shadow: BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 5)),
      child: Padding(
        padding: const EdgeInsets.only(
            right: 25.0, left: 25.0, bottom: 5.0, top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.todoModel.projectName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles().textStyleTodoCardProject),
                const SizedBox(height: 5),
                SizedBox(
                  height: widget.todoModel.content.length <= 24 ? 30 : 60,
                  width: 250,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Text(
                      widget.todoModel.content,
                      style: Styles().progressWidgetContent,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      TodoController().toDoProgressDuration(_duration) +
                          '  |  ',
                      style: Styles().timePassedVsDuration,
                    ),
                    Text(
                      TodoController().howMuchTimePassed(_timePassed),
                      style: Styles().timePassedVsDuration,
                    ),
                    const SizedBox(width: 5),
                  ],
                )
              ],
            ),
            percentIndicator()
          ],
        ),
      ),
    );
  }

  CircularPercentIndicator percentIndicator() {
    return CircularPercentIndicator(
      radius: 75,
      fillColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(.05),
      animateFromLastPercent: true,
      animation: true,
      addAutomaticKeepAlive: false,
      circularStrokeCap: CircularStrokeCap.round,
      animationDuration: 500,
      center: GestureDetector(
        onTap: () {
          timerOnOff();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (TodoController()
                              .percentageOfTimePassed(_duration, _timePassed) ==
                          0 ||
                      TodoController()
                              .percentageOfTimePassed(_duration, _timePassed)
                              .isNaN ==
                          true)
                  ? 'start'
                  : TodoController()
                          .percentageOfTimePassed(_duration, _timePassed)
                          .round()
                          .toString() +
                      '%',
              style: Styles().textStyleBlackSmallText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Container(
              height: 16,
              width: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.deepPurpleAccent[700]),
              child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  size: 10,
                  color: Colors.white,
                  progress: _animationController),
            ),
          ],
        ),
      ),
      progressColor: const Color(0xFF5430E5),
      lineWidth: 4.0,
      percent:
          TodoController().percentageOfTimePassed(_duration, _timePassed) / 100,
    );
  }
}
