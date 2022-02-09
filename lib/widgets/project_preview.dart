import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/utils/styles.dart';

class ProjectPreviewWidget extends StatefulWidget {
  const ProjectPreviewWidget(
      {Key? key,
      required this.projectName,
      required this.color,
      required this.height,
      required this.width,
      required this.cover,
      required this.isCreate})
      : super(key: key);

  final String projectName;
  final String color;
  final double height;
  final double width;
  final String cover;
  final bool isCreate;

  @override
  _ProjectPreviewWidgetState createState() => _ProjectPreviewWidgetState();
}

class _ProjectPreviewWidgetState extends State<ProjectPreviewWidget> {
  late TodoController _todoController;
  late int _retrivedColor;

  @override
  void initState() {
    _todoController = Get.find<TodoController>();
    super.initState();
  }

  int get howManyDone {
    var listModels = _todoController.todos
        .where((element) => element!.projectName == widget.projectName);
    var listDone = [];
    for (var item in listModels) {
      if (item!.isDone == true) {
        listDone.add(item);
      }
    }
    return widget.isCreate == true ? 2 : listDone.length;
  }

  double get percentage {
    int doneTasks = howManyDone;
    int allTasks = _todoController.todos
        .where((element) => element!.projectName == widget.projectName)
        .length;
    double result = doneTasks == 0 ? 0 : (doneTasks / allTasks);
    return widget.isCreate == true ? 0.5 : result;
  }

  @override
  Widget build(BuildContext context) {
    _retrivedColor = int.parse(widget.color);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.fromLTRB(25.0, 10.0, 5.0, 10.0),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35.0),
              color: Color(_retrivedColor).withOpacity(1.0)),
          child: GetX<TodoController>(
              init: Get.put<TodoController>(TodoController()),
              builder: (TodoController todoController) {
                {
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
                                  widget.isCreate == true
                                      ? '4'
                                      : todoController.todos
                                          .where((element) =>
                                              element!.projectName ==
                                              widget.projectName)
                                          .length
                                          .toString()
                                ]),
                                style: Styles.textStyleWhiteText
                                    .copyWith(fontSize: 13.0)),
                            SizedBox(
                              height: widget.height / 40.0,
                            ),
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 50.0,
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
                                style: Styles.textStyleProjectChipText
                                    .copyWith(fontSize: 10.0),
                              ),
                              progressColor: Colors.white.withOpacity(0.4),
                              lineWidth: 6.0,
                              percent: percentage,
                            ),
                            SizedBox(
                              height: widget.height / 80.0,
                            ),
                            SizedBox(
                              width: 120.0,
                              child: Text(
                                widget.projectName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Styles.projectNameProjectCard
                                    .copyWith(fontSize: 18.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 20.0,
                        child: SizedBox(
                          width: 110.0,
                          child: SvgPicture.network(
                            widget.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }
}
