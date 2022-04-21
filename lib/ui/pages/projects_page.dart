import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/ui/pages/inside_project_page.dart';
import '../../core/constants/constants.dart';
import '../ui_export.dart';

class ProjectsPage extends StatelessWidget {
  ProjectsPage({Key? key}) : super(key: key);
  final _projectController = Get.find<ProjectController>();

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        hoverElevation: 10.0,
        hoverColor: AppColors.darkPurple,
        splashColor: AppColors.darkPurple,
        elevation: 30.0,
        backgroundColor: AppColors.mainPurple,
        onPressed: () => _projectController.openCreateProject(
          context: context,
          projectModel: null,
          isCreate: true,
        ),
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20.0),
              Text(
                'projectsPage'.tr,
                style: AppTextStyles.textStyleTitle,
              ),
              const SizedBox(height: 20.0),
              GetX<ProjectController>(
                builder: (_) {
                  if (_projectController.projects.isNotEmpty) {
                    return _projectsList(width);
                  } else {
                    return const EmptyProjects();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _projectsList(double width) {
    return ListView.builder(
      shrinkWrap: true,
      itemExtent: 210,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: _projectController.projects.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () => Get.to(
              () => InsideProjectPage(
                    projectModel: _projectController.projects[index]!,
                  ),
              transition: Transition.native,
              duration: const Duration(milliseconds: 350)),
          child: ProjectCard(
            cover: _projectController.projects[index]!.projectCover,
            height: 190.0,
            width: width,
            projectName: _projectController.projects[index]!.projectName,
            color: _projectController.projects[index]!.color,
          ),
        );
      },
    );
  }
}
