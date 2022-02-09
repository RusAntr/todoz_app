import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/pages/inside_project_page.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/empty_projects_widget.dart';
import 'package:todoz_app/widgets/project_card_widget.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: ListView(physics: const BouncingScrollPhysics(), children: [
            const SizedBox(height: 20.0),
            Text('projectsPage'.tr, style: Styles.textStyleTitle),
            const SizedBox(height: 20.0),
            GetX<ProjectController>(
                init: Get.put<ProjectController>(ProjectController()),
                builder: (ProjectController projectController) {
                  if (projectController.projects.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemExtent: 210.0,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: projectController.projects.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () => Get.to(
                              InsideProjectPage(
                                projectModel:
                                    projectController.projects[index]!,
                              ),
                              transition: Transition.native,
                              duration: const Duration(milliseconds: 350)),
                          child: ProjectCardWidget(
                            cover:
                                projectController.projects[index]!.projectCover,
                            height: 190,
                            width: width,
                            projectName:
                                projectController.projects[index]!.projectName,
                            color: projectController.projects[index]!.color,
                          ),
                        );
                      },
                    );
                  } else {
                    return const EmptyProjectsWidget();
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
