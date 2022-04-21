import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import '../../core/constants/constants.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
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
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late TodoController _todoController;

  @override
  void initState() {
    _todoController = Get.find<TodoController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.fromLTRB(25.0, 10.0, 5.0, 10.0),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: AppColors().getColor(widget.color).withOpacity(1.0),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            fit: StackFit.expand,
            children: [
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tasksTitle(),
                    SizedBox(
                      height: widget.height / 40.0,
                    ),
                    _progressIndicator(),
                    SizedBox(
                      height: widget.height / 80.0,
                    ),
                    _projectName(),
                  ],
                ),
              ),
              _projectCover(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _projectCover() {
    return Positioned(
      right: 20.0,
      child: SizedBox(
        width: 120.0,
        child: CachedNetworkImage(
          imageUrl: widget.cover,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _projectName() {
    return SizedBox(
      width: widget.width / 3.7,
      child: Text(
        widget.projectName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: AppTextStyles.projectNameProjectCard,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _progressIndicator() {
    double percentage =
        _todoController.doneTasksInProjectPercent(widget.projectName);
    return CircularPercentIndicator(
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
                : (percentage * 100).toStringAsFixed(2) + '%',
        style: AppTextStyles.textStyleProjectChipText,
      ),
      progressColor: Colors.white.withOpacity(0.4),
      lineWidth: 6.0,
      percent: percentage,
    );
  }

  Widget _tasksTitle() {
    return Obx(
      () => Text(
        _todoController.allTasksInProjectTitle(widget.projectName),
        style: AppTextStyles.textStyleWhiteText,
      ),
    );
  }
}
