import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({Key? key, required this.todoModel, required this.uid})
      : super(key: key);

  final String uid;
  final TodoModel todoModel;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late final Timer _timer;
  late bool _showDateUntil;

  @override
  void initState() {
    _showDateUntil = false;
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get correctFormatDate {
    String correctFormatDate;
    if (widget.todoModel.dateUntil != null) {
      correctFormatDate =
          widget.todoModel.dateUntil!.toDate().format('j.m.Y, h:i');
    } else {
      correctFormatDate = '';
    }
    return correctFormatDate;
  }

  void updateTodo() {
    Database().updateTodo(
        widget.todoModel.isDone == false ? true : false,
        widget.uid,
        widget.todoModel.todoId,
        ProjectController.getProjectId(widget.todoModel),
        widget.todoModel.projectName,
        widget.todoModel.timePassed);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        GestureDetector(
          onLongPress: () {
            updateTodo();
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 9.0),
              height: 150.0,
              width: 160.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.todoModel.isDone == true
                      ? const Color(0xFFDFFFD4)
                      : const Color(0xFFEFF0FA)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todoModel.projectName,
                    style: Styles.projectNameTodoCard,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    widget.todoModel.content.toString(),
                    style: widget.todoModel.isDone == true
                        ? Styles.textStyleToDoDoneText
                        : Styles.textStyleToDoUndoneText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_showDateUntil == true) {
                          _showDateUntil = false;
                        } else if (_showDateUntil == false) {
                          _showDateUntil = true;
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        correctFormatDate == ''
                            ? Container()
                            : const Icon(Icons.circle,
                                size: 8, color: Color(0xFF84E563)),
                        const SizedBox(width: 5),
                        _showDateUntil == false &&
                                widget.todoModel.isDone == false
                            ? Text(
                                widget.todoModel.dateUntil != null
                                    ? TodoController().countUntilTime(
                                        widget.todoModel.dateUntil!)
                                    : '',
                                style: Styles.textStyleDoneText,
                              )
                            : Text('till'.tr + correctFormatDate,
                                style: Styles.textStyleDoneText),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
