// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:todoz_app/models/todoModel.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';

class TodoCard extends StatelessWidget {
  final String? uid;
  final String? todoId;
  final TodoModel? todoModel;

  const TodoCard({Key? key, this.todoModel, this.todoId, this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const SizedBox(width: 5),
        GestureDetector(
          onLongPress: () {
            if (todoModel!.isDone == false) {
              var a = todoModel!.isDone = true;
              Database().updateTodo(a, uid!, todoModel!.todoId!);
            } else {
              var a = todoModel!.isDone = false;
              Database().updateTodo(a, uid!, todoModel!.todoId!);
            }
          },
          child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              height: height / 4.5,
              width: width / 2.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: todoModel!.isDone == true
                      ? Color(0xFFDFFFD4)
                      : Color(0xFFEFF0FA)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todoModel!.content.toString(),
                    style: todoModel!.isDone == true
                        ? Styles().textStyleToDoDoneText
                        : Styles().textStyleToDoUndoneText,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      todoModel!.isDone == true
                          ? Text(
                              'taskDone'.tr,
                              style: Styles().textStyleDoneText,
                            )
                          : Text('taskUndone'.tr,
                              style: Styles().textStyleDoneText),
                      Text(
                        todoModel!.dateCreated!
                            .toDate()
                            .format('M, j')
                            .toString(),
                        //.substring(5, 16),
                        style: Styles().textStyleDoneText,
                      ),
                    ],
                  ),
                ],
              )),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
