import 'package:date_time_format/src/date_time_extension_methods.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';

class TodoCardInProjectWidget extends StatefulWidget {
  const TodoCardInProjectWidget(
      {Key? key,
      required this.todoModel,
      required this.uid,
      required this.projectName,
      required this.projectColor,
      required this.projectId})
      : super(key: key);

  final TodoModel todoModel;
  final String uid;
  final String projectColor;
  final String projectName;
  final String projectId;
  @override
  State<TodoCardInProjectWidget> createState() =>
      _TodoCardInProjectWidgetState();
}

class _TodoCardInProjectWidgetState extends State<TodoCardInProjectWidget> {
  void onSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.endToStart) {
      Database().updateTodo(
          true,
          widget.uid,
          widget.todoModel.todoId,
          widget.projectId,
          widget.todoModel.projectName,
          widget.todoModel.timePassed);
    } else if (direction == SwipeDirection.startToEnd) {
      Database()
          .deleteTodo(widget.todoModel.todoId, widget.uid, widget.projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    int retrivedColor = int.parse(widget.projectColor);
    double width = Get.width;
    return SwipeableTile.swipeToTiggerCard(
      borderRadius: 25,
      swipeThreshold: 0.2,
      direction: SwipeDirection.horizontal,
      color:
          widget.todoModel.isDone == true ? Color(retrivedColor) : Colors.white,
      verticalPadding: 10,
      horizontalPadding: 15,
      shadow: BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 5)),
      key: Key(widget.todoModel.todoId),
      onSwiped: (direction) => onSwipe(direction),
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
                borderRadius: BorderRadius.circular(25),
                color: Colors.red,
              ),
              alignment: Alignment.centerLeft,
              height: 20,
              width: 20,
              child: const Icon(EvaIcons.trash2Outline, color: Colors.white));
        }
        return Container();
      },
      child: GestureDetector(
        onLongPress: () {
          Database().updateTodo(
              widget.todoModel.isDone == true ? false : true,
              widget.uid,
              widget.todoModel.todoId,
              widget.projectId,
              widget.projectName,
              widget.todoModel.timePassed);
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: widget.todoModel.isDone == false
                      ? Colors.white
                      : Color(retrivedColor)),
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
                        SizedBox(
                          height:
                              widget.todoModel.content.length <= 35 ? 30 : 60,
                          width: 250,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Text(
                              widget.todoModel.content,
                              style: widget.todoModel.isDone == true
                                  ? Styles.textStyleProjectName
                                  : Styles.todoContentProgressive,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
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
                                  ? Styles.textStyleTodoWidgetDateBlack
                                  : Styles.textStyleTodoWidgetDateWhite,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(widget.todoModel.isDone == true ? 'taskDone'.tr : '',
                        style: Styles.textStyleProjectNamePreview),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
