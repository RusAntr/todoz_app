import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import '../../core/constants/constants.dart';

class ProjectPreview extends StatefulWidget {
  const ProjectPreview({
    Key? key,
    required this.projectName,
    required this.color,
    required this.height,
    required this.width,
    required this.cover,
    required this.isCreate,
  }) : super(key: key);

  final String projectName;
  final String color;
  final double height;
  final double width;
  final String cover;
  final bool isCreate;

  @override
  _ProjectPreviewState createState() => _ProjectPreviewState();
}

class _ProjectPreviewState extends State<ProjectPreview> {
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
          child: GetX<TodoController>(
            builder: (TodoController todoController) => Stack(
              alignment: Alignment.centerRight,
              fit: StackFit.expand,
              children: [
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleTasks(),
                      _procentIndicator(),
                      _projectName(),
                    ],
                  ),
                ),
                _projectCover(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleTasks() {
    return Text(_todoController.allTasksInProjectTitle(widget.projectName),
        style: AppTextStyles.textStyleWhiteText.copyWith(fontSize: 13.0));
  }

  Widget _projectCover() {
    return Positioned(
      right: 20.0,
      child: SizedBox(
        width: 110.0,
        child: CachedNetworkImage(
          imageUrl: widget.cover,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _projectName() {
    return SizedBox(
      width: 120.0,
      child: Text(
        widget.projectName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: AppTextStyles.projectNameProjectCard.copyWith(fontSize: 16.0),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _procentIndicator() {
    double percentage = widget.isCreate
        ? 0.5
        : _todoController.doneTasksInProjectPercent(widget.projectName);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        radius: 55.0,
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
          style:
              AppTextStyles.textStyleProjectChipText.copyWith(fontSize: 10.5),
        ),
        progressColor: Colors.white.withOpacity(0.4),
        lineWidth: 6.0,
        percent: percentage,
      ),
    );
  }
}
