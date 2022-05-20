import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/custom_snackbars.dart';
import 'package:todoz_app/core/date_time_formatting.dart';
import 'package:todoz_app/ui/ui_export.dart';
import '../../core/constants/constants.dart';
import '../../data/models/models.dart';

class TodoCardInProject extends StatefulWidget {
  const TodoCardInProject({
    Key? key,
    required this.todoModel,
    required this.projectColor,
    required this.projectId,
  }) : super(key: key);

  final TodoModel todoModel;
  final String projectColor;
  final String projectId;
  @override
  State<TodoCardInProject> createState() => _TodoCardInProjectState();
}

class _TodoCardInProjectState extends State<TodoCardInProject> {
  final TodoController _todoController = Get.find<TodoController>();
  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    return widget.todoModel.duration != null
        ? TodoProgressiveCard(
            todoModel: widget.todoModel,
            projectColor: AppColors().getColor(widget.projectColor),
            key: Key(widget.todoModel.todoId),
          )
        : _swipableTile(width);
  }

  SwipeableTile _swipableTile(double width) {
    return SwipeableTile.swipeToTiggerCard(
      borderRadius: 25,
      swipeThreshold: 0.2,
      direction: SwipeDirection.horizontal,
      color: widget.todoModel.isDone
          ? AppColors().getColor(widget.projectColor)
          : Colors.white,
      verticalPadding: 10,
      horizontalPadding: 15,
      shadow: BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 5)),
      key: Key(widget.todoModel.todoId),
      onSwiped: (direction) => _onSwipe(direction),
      backgroundBuilder: (context, direction, _) => _buildBackground(direction),
      child: GestureDetector(
        onLongPress: () {
          _todoController.updateTodo(
            newValue: widget.todoModel.isDone ? false : true,
            todoId: widget.todoModel.todoId,
            projectId: widget.projectId,
            projectName: widget.todoModel.projectName,
            timePassed: widget.todoModel.timePassed,
          );
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: !widget.todoModel.isDone
                    ? Colors.white
                    : AppColors().getColor(widget.projectColor),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _todoContent(),
                        const SizedBox(height: 15.0),
                        _todoDateRow(),
                      ],
                    ),
                    Text(
                      widget.todoModel.isDone ? 'taskDone'.tr : '',
                      style: AppTextStyles.textStyleProjectNamePreview,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _todoContent() {
    return SizedBox(
      width: widget.todoModel.isDone ? Get.width / 1.65 : Get.width / 1.5,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SelectableText(
          widget.todoModel.content,
          maxLines: 2,
          style: widget.todoModel.isDone
              ? AppTextStyles.whiteTitleNormal
                  .copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.todoContentProgressive,
        ),
      ),
    );
  }

  Widget _todoDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          EvaIcons.calendarOutline,
          size: 20,
          color: !widget.todoModel.isDone
              ? Colors.black.withOpacity(0.5)
              : Colors.white.withOpacity(0.5),
        ),
        const SizedBox(width: 5),
        Text(
          DateTimeFormatting.dateText(
            false,
            '',
            widget.todoModel.dateCreated.toDate(),
          ),
          style: !widget.todoModel.isDone
              ? AppTextStyles.textStyleTodoWidgetDateBlack
              : AppTextStyles.textStyleTodoWidgetDateWhite,
        ),
      ],
    );
  }

  Widget _buildBackground(SwipeDirection direction) {
    if (direction == SwipeDirection.endToStart) {
      if (!widget.todoModel.isDone) {
        return Container(
          padding: const EdgeInsets.only(right: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.green,
          ),
          alignment: Alignment.centerRight,
          child: const Icon(EvaIcons.doneAll, color: Colors.white),
        );
      } else {
        return Container(
            padding: const EdgeInsets.only(right: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            child: const Icon(EvaIcons.undo, color: Colors.white));
      }
    } else if (direction == SwipeDirection.startToEnd) {
      return Container(
        padding: const EdgeInsets.only(left: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.red,
        ),
        alignment: Alignment.centerLeft,
        height: 20,
        width: 20,
        child: const Icon(EvaIcons.trash2Outline, color: Colors.white),
      );
    }
    return Container();
  }

  void _onSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.endToStart) {
      _todoController.updateTodo(
        newValue: widget.todoModel.isDone ? false : true,
        todoId: widget.todoModel.todoId,
        projectId: widget.projectId,
        projectName: widget.todoModel.projectName,
        timePassed: widget.todoModel.timePassed,
      );
    } else if (direction == SwipeDirection.startToEnd) {
      var deletedTodo = widget.todoModel.copyWith();
      CustomSnackbars.undoDeleteTodo(
        title: 'deletedSuccessfully'.tr,
        message: 'clickUndo'.tr,
        deletedTodo: deletedTodo,
        projectId: widget.projectId,
      );

      _todoController.deleteTodo(
        todoId: widget.todoModel.todoId,
        projectId: widget.projectId,
      );
    }
  }
}
