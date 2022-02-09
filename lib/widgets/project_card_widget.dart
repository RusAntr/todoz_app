import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoz_app/utils/styles.dart';

class ProjectCardWidget extends StatefulWidget {
  const ProjectCardWidget({
    Key? key,
    required this.color,
    required this.projectName,
    required this.height,
    required this.width,
    required this.cover,
  }) : super(key: key);

  final String projectName;
  final String color;
  final double height;
  final double width;
  final String cover;

  @override
  State<ProjectCardWidget> createState() => _ProjectCardWidgetState();
}

class _ProjectCardWidgetState extends State<ProjectCardWidget> {
  late TodoController _todoController;
  late int _retrivedColor;

  int get howManyDone {
    var listModels = _todoController.todos
        .where((element) => element!.projectName == widget.projectName);
    var listDone = [];
    for (var item in listModels) {
      if (item!.isDone == true) {
        listDone.add(item);
      }
    }
    return listDone.length;
  }

  double get percentage {
    int doneTasks = howManyDone;
    int allTasks = _todoController.todos
        .where((element) => element!.projectName == widget.projectName)
        .length;

    double result = doneTasks == 0 ? 0 : (doneTasks / allTasks);
    return result;
  }

  @override
  void initState() {
    _todoController = Get.find<TodoController>();
    super.initState();
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
            child: Stack(
              alignment: Alignment.centerRight,
              fit: StackFit.expand,
              children: [
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                          'numberOfTasks'.trArgs([
                            howManyDone.toString(),
                            _todoController.todos
                                .where((element) =>
                                    element!.projectName == widget.projectName)
                                .length
                                .toString()
                          ]),
                          style: Styles.textStyleWhiteText)),
                      SizedBox(
                        height: widget.height / 40.0,
                      ),
                      Obx(() => CircularPercentIndicator(
                            circularStrokeCap: CircularStrokeCap.round,
                            radius: 60.0,
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
                              style: Styles.textStyleProjectChipText,
                            ),
                            progressColor: Colors.white.withOpacity(0.4),
                            lineWidth: 6.0,
                            percent: percentage,
                          )),
                      SizedBox(
                        height: widget.height / 80.0,
                      ),
                      SizedBox(
                        width: widget.width / 3.7,
                        child: Text(
                          widget.projectName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Styles.projectNameProjectCard,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20.0,
                  child: SizedBox(
                    width: 120.0,
                    child: SvgPicture.network(
                      widget.cover,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
