import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/widgets/create_change_project_widget.dart';

class ProjectController extends GetxController {
  final Rx<List<ProjectModel?>> _projectList = Rx<List<ProjectModel?>>([]);

  List<ProjectModel?> get projects => _projectList.value;

  @override
  onInit() {
    String uid = Get.find<AuthController>().user!.uid;
    _projectList.bindStream(Database().getProjects(uid));
    super.onInit();
  }

  String getProjectId(TodoModel todoModel) {
    String projectId;
    if (todoModel.projectName == 'NoProject') {
      projectId = 'NoProject';
    } else {
      final project = Get.find<ProjectController>();
      projectId = project.projects
          .where((element) => element!.projectName == todoModel.projectName)
          .first!
          .projectId;
    }
    return projectId;
  }

  void addProject(TextEditingController controller, String uid, Color color,
      String projectCover) {
    if (controller.text != "") {
      Database().addProject(
          color: color,
          projectName: controller.text,
          uid: uid,
          projectCover: projectCover);
      controller.clear();
    } else {
      Get.snackbar('Error', 'Error 2', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void openCreateProject(BuildContext context, ProjectModel? projectModel,
      bool isCreate, List<TodoModel?>? todoModel) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              children: [
                CreateProjectWidget(
                  projectModel: projectModel,
                  isCreate: isCreate,
                  todoModel: todoModel,
                )
              ],
            ));
  }
}
