import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/data/api/firestore_api.dart';
import 'package:todoz_app/core/custom_snackbars.dart';
import 'package:todoz_app/ui/ui_export.dart';
import '../data/models/models.dart';

class ProjectController extends GetxController {
  /// Observable list of [ProjectModel]s
  final Rx<List<ProjectModel?>> _projectList = Rx<List<ProjectModel?>>([]);

  /// Getter for [ProjectController]
  List<ProjectModel?> get projects => _projectList.value;

  final FirestoreApi _firestoreRepository = FirestoreApi();
  late String _uid;

  @override
  onInit() {
    _uid = Get.find<AuthController>().user!.uid;
    _projectList.bindStream(FirestoreApi().getProjects(_uid));
    super.onInit();
  }

  @override
  onClose() {
    _projectList.close();
    super.onClose();
  }

  /// Returns project's id for [TodoModel]
  String getProjectId(TodoModel todoModel) {
    String projectId = projects
        .singleWhere(
            (project) => project!.projectName == todoModel.projectName)!
        .projectId;
    return projectId;
  }

  /// Adds new [ProjectModel] to Firebase's database
  void addProject({
    required TextEditingController controller,
    required Color color,
    required String projectCover,
  }) {
    if (controller.text != "" &&
        projects
                .where((element) => element!.projectName == controller.text)
                .length ==
            0.0) {
      _firestoreRepository.addProject(
        color: color,
        projectName: controller.text,
        uid: _uid,
        projectCover: projectCover,
      );
      controller.clear();
      update();
    } else {
      CustomSnackbars.error('Error', 'Project already exist');
    }
  }

  /// Deletes [ProjectModel] from Firestore and navigates user back to ProjectsPage
  Future<void> deleteProject({
    required String projectId,
    List<TodoModel?>? todoModels,
  }) async {
    Get.back();
    Get.back();
    await Future.delayed(
      const Duration(seconds: 1),
    );
    _firestoreRepository.deleteProject(
      uid: _uid,
      projectId: projectId,
      todoModels: todoModels,
    );
    update();
  }

  /// Updates [ProjectModel]. If there are [TodoModel]s in the project they will also be updated
  void updateProject({
    required Color color,
    required String projectCover,
    required String projectName,
    required String projectId,
    List<TodoModel?>? todoModels,
  }) {
    _firestoreRepository.updateProject(
      color: color,
      uid: _uid,
      projectCover: projectCover,
      projectName: projectName,
      projectId: projectId,
      todoModels: todoModels,
    );
  }

  /// Opens dialog for creating new [ProjectModel]
  void openCreateProject({
    required BuildContext context,
    required ProjectModel? projectModel,
    required bool isCreate,
    List<TodoModel?>? todoModels,
  }) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        children: [
          CreateChangeProject(
            projectModel: projectModel,
            isCreate: isCreate,
            todoModels: todoModels,
          )
        ],
      ),
    );
  }
}
