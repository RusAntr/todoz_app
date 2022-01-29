import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoz_app/utils/styles.dart';

class ProjectCardWidget extends StatefulWidget {
  final String projectName;
  final String color;
  final double height;
  final double width;
  final String cover;
  final bool isCreate;

  const ProjectCardWidget(
      {Key? key,
      required this.color,
      required this.projectName,
      required this.height,
      required this.width,
      required this.cover,
      required this.isCreate})
      : super(key: key);

  @override
  State<ProjectCardWidget> createState() => _ProjectCardWidgetState();
}

class _ProjectCardWidgetState extends State<ProjectCardWidget> {
  late TodoController todoController;
  late int retrivedColor;

  int get howManyDone {
    var listModels = todoController.todos
        .where((element) => element!.projectName == widget.projectName);
    var listDone = [];
    for (var item in listModels) {
      if (item!.isDone == true) {
        listDone.add(item);
      }
    }
    return widget.height > 400 ? listDone.length : 2;
  }

  double get percentage {
    int doneTasks = howManyDone;
    int allTasks = widget.height > 400
        ? todoController.todos
            .where((element) => element!.projectName == widget.projectName)
            .length
        : 4;

    double result = doneTasks == 0 ? 0 : (doneTasks / allTasks);
    return result;
  }

  @override
  void initState() {
    todoController = Get.find<TodoController>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    retrivedColor = int.parse(widget.color);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.fromLTRB(25, 9, 5, 9),
          height: widget.height / 2.1,
          width: widget.width - 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Color(retrivedColor).withOpacity(1)),
          child: GetX<TodoController>(
              init: Get.put<TodoController>(TodoController()),
              builder: (TodoController todoController) {
                if (todoController.todos.isNotEmpty) {
                  return Stack(
                    alignment: Alignment.centerRight,
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'numberOfTasks'.trArgs([
                                  howManyDone.toString(),
                                  widget.height > 400
                                      ? todoController.todos
                                          .where((element) =>
                                              element!.projectName ==
                                              widget.projectName)
                                          .length
                                          .toString()
                                      : '4'
                                ]),
                                style: Styles().textStyleWhiteText),
                            SizedBox(
                              height: widget.height / 40,
                            ),
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: widget.height > 400 ? 60 : 50,
                              fillColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              animateFromLastPercent: true,
                              animation: true,
                              animationDuration: 500,
                              center: Text(
                                (percentage == 0)
                                    ? ''
                                    : (percentage == 1)
                                        ? '100%'
                                        : (percentage * 100)
                                                .toString()
                                                .substring(0, 4) +
                                            '%',
                                style: widget.height > 400
                                    ? Styles().textStyleProjectChipText
                                    : Styles().textStyleProgressPreview,
                              ),
                              progressColor: Colors.white.withOpacity(0.4),
                              lineWidth: widget.height > 400 ? 6.0 : 4.5,
                              percent: percentage,
                            ),
                            SizedBox(
                              height: widget.height / 80,
                            ),
                            SizedBox(
                              width: widget.width / 3.7,
                              child: Text(
                                widget.projectName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: widget.height > 400
                                    ? Styles().textStyleWhiteBigText
                                    : Styles().textStyleProjectNamePreview,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: SizedBox(
                          width: widget.height > 400 ? 150 : 120,
                          child: SvgPicture.network(
                            widget.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: widget.height / 40),
                            Text('noTasks'.tr,
                                style: Styles().textStyleWhiteBigText)
                          ],
                        ),
                      ]);
                }
              }),
        ),
      ],
    );
  }
}
