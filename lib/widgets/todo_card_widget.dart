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
  final String uid;
  final TodoModel todoModel;
  const TodoCard({Key? key, required this.todoModel, required this.uid})
      : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late final Timer timer;
  late bool showDateUntil;

  @override
  void initState() {
    showDateUntil = false;
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const SizedBox(width: 15),
        GestureDetector(
          onLongPress: () {
            Database().updateTodo(
                widget.todoModel.isDone == false ? true : false,
                widget.uid,
                widget.todoModel.todoId,
                ProjectController().getProjectId(widget.todoModel),
                widget.todoModel.projectName,
                widget.todoModel.timePassed);
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 9),
              height: height / 5,
              width: width / 2.8,
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
                    style: Styles().textStyleTodoCardProject,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    widget.todoModel.content.toString(),
                    style: widget.todoModel.isDone == true
                        ? Styles().textStyleToDoDoneText
                        : Styles().textStyleToDoUndoneText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (showDateUntil == true) {
                          showDateUntil = false;
                        } else if (showDateUntil == false) {
                          showDateUntil = true;
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
                        showDateUntil == false &&
                                widget.todoModel.isDone == false
                            ? Text(
                                widget.todoModel.dateUntil != null
                                    ? TodoController().countUntilTime(
                                        widget.todoModel.dateUntil!)
                                    : '',
                                style: Styles().textStyleDoneText,
                              )
                            : Text('till'.tr + correctFormatDate,
                                style: Styles().textStyleDoneText),
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
