// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:todoz_app/controllers/projectController.dart';
import 'package:todoz_app/models/todoModel.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';

class TodoCard extends StatelessWidget {
  final String? uid;
  final TodoModel todoModel;

  const TodoCard({Key? key, required this.todoModel, this.uid})
      : super(key: key);

  String get projectId {
    String projectId;
    if (todoModel.projectName == 'NoProject') {
      projectId = 'NoProject';
    } else {
      final project = Get.find<ProjectController>();
      projectId = project.projects
          .where((element) => element!.projectName == todoModel.projectName)
          .first!
          .projectId;
    }
    return projectId;
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
            if (todoModel.isDone == false) {
              bool newValue = todoModel.isDone = true;
              Database().updateTodo(newValue, uid!, todoModel.todoId, projectId,
                  todoModel.projectName);
            } else {
              bool newValue = todoModel.isDone = false;
              Database().updateTodo(newValue, uid!, todoModel.todoId, projectId,
                  todoModel.projectName);
            }
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 9),
              height: height / 5,
              width: width / 2.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: todoModel.isDone == true
                      ? const Color(0xFFDFFFD4)
                      : const Color(0xFFEFF0FA)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todoModel.projectName,
                    style: Styles().textStyleTodoCardProject,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    todoModel.content.toString(),
                    style: todoModel.isDone == true
                        ? Styles().textStyleToDoDoneText
                        : Styles().textStyleToDoUndoneText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      todoModel.isDone == true
                          ? Text(
                              'taskDone'.tr,
                              style: Styles().textStyleDoneText,
                            )
                          : Text('taskUndone'.tr,
                              style: Styles().textStyleDoneText),
                      Text(
                        todoModel.dateCreated
                            .toDate()
                            .format('M, j')
                            .toString(),
                        style: Styles().textStyleDoneText,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
