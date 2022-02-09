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
    String _uid = Get.find<AuthController>().user!.uid;
    _projectList.bindStream(Database().getProjects(_uid));
    super.onInit();
  }

  /// Get project's ID for a [TodoModel]
  static String getProjectId(TodoModel todoModel) {
    String projectId = Get.find<ProjectController>()
        .projects
        .singleWhere(
            (project) => project!.projectName == todoModel.projectName)!
        .projectId;
    return projectId;
  }

  /// Adds new [ProjectModel] to [Firestore]'s database
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

  /// Opens dialog for creating new [ProjectModel]
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
                  todoModels: todoModel,
                )
              ],
            ));
  }
}
