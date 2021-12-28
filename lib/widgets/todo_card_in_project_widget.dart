import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todoz_app/models/todoModel.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';

class TodoCardInProjectWidget extends StatefulWidget {
  final TodoModel todoModel;
  final String uid;
  final String projectColor;
  final String projectName;
  final String projectId;
  const TodoCardInProjectWidget(
      {Key? key,
      required this.todoModel,
      required this.uid,
      required this.projectName,
      required this.projectColor,
      required this.projectId})
      : super(key: key);

  @override
  State<TodoCardInProjectWidget> createState() =>
      _TodoCardInProjectWidgetState();
}

class _TodoCardInProjectWidgetState extends State<TodoCardInProjectWidget> {
  @override
  Widget build(BuildContext context) {
    int retrivedColor = int.parse(widget.projectColor);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () {
        if (widget.todoModel.isDone == false) {
          bool newValue = widget.todoModel.isDone = true;
          Database().updateTodo(
            newValue,
            widget.uid,
            widget.todoModel.todoId,
            widget.projectId,
            widget.projectName,
          );
        } else {
          bool newValue = widget.todoModel.isDone = false;
          Database().updateTodo(newValue, widget.uid, widget.todoModel.todoId,
              widget.projectId, widget.projectName);
        }
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: width - 30,
            height: height / 7,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 10),
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.circular(25),
                color: widget.todoModel.isDone == false
                    ? Colors.white
                    : Color(retrivedColor)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width / 1.7,
                        child: Text(
                          widget.todoModel.content,
                          style: widget.todoModel.isDone == true
                              ? Styles().textStyleTodoNameWidgetWhite
                              : Styles().textStyleTodoNameWidgetBlack,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            EvaIcons.calendarOutline,
                            size: 20,
                            color: widget.todoModel.isDone == false
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.todoModel.dateCreated
                                .toDate()
                                .format('M, j')
                                .toString(),
                            style: widget.todoModel.isDone == false
                                ? Styles().textStyleTodoWidgetDateBlack
                                : Styles().textStyleTodoWidgetDateWhite,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(widget.todoModel.isDone == true ? 'taskDone'.tr : '',
                      style: Styles().textStyleProjectNamePreview),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
