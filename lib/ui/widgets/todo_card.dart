import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/date_time_formatting.dart';
import '../../core/constants/constants.dart';
import '../../data/models/models.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    Key? key,
    required this.todoModel,
  }) : super(key: key);
  final TodoModel todoModel;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late final Timer _timer;
  late bool _showDateUntil;
  late ProjectController _projectController;
  final TodoController _todoController = Get.find<TodoController>();

  @override
  void initState() {
    _projectController = Get.find<ProjectController>();
    _showDateUntil = false;
    _timer =
        Timer.periodic(const Duration(seconds: 30), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void updateTodo() {
    _todoController.updateTodo(
      newValue: true,
      todoId: widget.todoModel.todoId,
      projectId: _projectController.getProjectId(widget.todoModel),
      projectName: widget.todoModel.projectName,
      timePassed: widget.todoModel.timePassed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          const SizedBox(width: 15.0),
          GestureDetector(
            onLongPress: () => updateTodo(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              height: 150.0,
              width: 165.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: AppColors.accentBlue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todoModel.projectName,
                    style: AppTextStyles.projectNameTodoCard,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    widget.todoModel.content.toString(),
                    style: AppTextStyles.textStyleToDoUndoneText,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(
                    onTap: () => setState(
                      () {
                        if (_showDateUntil == true) {
                          _showDateUntil = false;
                        } else if (_showDateUntil == false) {
                          _showDateUntil = true;
                        }
                      },
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DateTimeFormatting.correctFormatDate(
                                    widget.todoModel) ==
                                ''
                            ? Container()
                            : const Icon(
                                Icons.circle,
                                size: 8,
                                color: AppColors.mainGreen,
                              ),
                        const SizedBox(width: 5),
                        _showDateUntil == false &&
                                widget.todoModel.isDone == false
                            ? Text(
                                widget.todoModel.dateUntil != null
                                    ? DateTimeFormatting.countUntilTime(
                                        widget.todoModel.dateUntil!)
                                    : '',
                                style: AppTextStyles.textStyleDoneText,
                              )
                            : Text(
                                'till'.tr +
                                    DateTimeFormatting.correctFormatDate(
                                        widget.todoModel),
                                style: AppTextStyles.textStyleDoneText,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
