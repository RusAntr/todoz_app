import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todoz_app/controllers/projectController.dart';
import 'package:todoz_app/pages/inside_project_page.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/project_card_widget.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text('projectsPage'.tr, style: Styles().textStyleTitle),
        ),
      ),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height / 40),
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GetX<ProjectController>(
                      init: Get.put<ProjectController>(ProjectController()),
                      builder: (ProjectController projectController) {
                        if (projectController.isBlank != true &&
                            projectController.projects.isNotEmpty) {
                          return SizedBox(
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemExtent: 210,
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
                                    transition: Transition.leftToRight,
                                    duration:
                                        const Duration(milliseconds: 500)),
                                child: ProjectCardWidget(
                                  isCreate: false,
                                  cover: projectController
                                      .projects[index]!.projectCover,
                                  height: width,
                                  width: height,
                                  projectName: projectController
                                      .projects[index]!.projectName,
                                  color:
                                      projectController.projects[index]!.color,
                                ),
                              );
                            },
                          ));
                        } else {
                          return const Text('loading');
                        }
                      }))
            ])
      ]),
    );
  }
}
