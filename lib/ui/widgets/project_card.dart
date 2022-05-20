import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/data/models/models.dart';
import '../../core/constants/constants.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.height,
    required this.width,
    required this.projectModel,
  }) : super(key: key);

  final ProjectModel projectModel;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    var _todoController = Get.find<TodoController>();
    double percentage =
        _todoController.doneTasksInProjectPercent(projectModel.projectName);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.fromLTRB(25.0, 15.0, 5.0, 15.0),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: AppColors().getColor(projectModel.color).withOpacity(1.0),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            fit: StackFit.expand,
            children: [
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tasksTitle(_todoController),
                    SizedBox(
                      height: height / 40.0,
                    ),
                    Text(
                      (percentage == 0)
                          ? '0%'
                          : (percentage == 1)
                              ? '100%'
                              : (percentage * 100).toStringAsFixed(2) + '%',
                      style: AppTextStyles.blackTitleNormal.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    SizedBox(
                      height: height / 80.0,
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
        height: 120.0,
        child: RepaintBoundary(
          child: RiveAnimation.asset(
              'assets/images_and_animations/project_covers/${projectModel.projectCover}_project.riv'),
        ),
      ),
    );
  }

  Widget _projectName() {
    return SizedBox(
      width: width / 2,
      child: Text(
        projectModel.projectName,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: AppTextStyles.projectNameProjectCard,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _tasksTitle(TodoController _todoController) {
    return Obx(
      () => Text(
        _todoController.allTasksInProjectTitle(projectModel.projectName),
        style: AppTextStyles.textStyleWhiteText,
      ),
    );
  }
}
