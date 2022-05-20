import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/data/api/firestore_api.dart';
import 'package:todoz_app/core/custom_snackbars.dart';
import 'package:todoz_app/ui/ui_export.dart';
import '../data/models/models.dart';

enum ProjectSortType {
  byDateCreated,
  byName,
}

class ProjectController extends GetxController {
  /// Observable list of [ProjectModel]s
  final Rx<List<ProjectModel?>> _projectsList = Rx<List<ProjectModel?>>([]);

  /// Returns a sorted list of [ProjectModel]'s
  List<ProjectModel?> get projects {
    return _projectsList.value;
  }

  final FirestoreApi _firestoreRepository = FirestoreApi();
  late String _uid;

  @override
  onInit() {
    _uid = Get.find<AuthController>().user!.uid;
    _projectsList.bindStream(FirestoreApi().getProjects(_uid));
    super.onInit();
  }

  @override
  onClose() {
    _projectsList.close();
    super.onClose();
  }

  /// Sorts [ProjectModel]s in the observable [_projectsList]
  void sort(ProjectSortType sortType, bool isAscending) {
    _projectsList.value.sort(
      (a, b) {
        switch (sortType) {
          case ProjectSortType.byDateCreated:
            return isAscending
                ? b!.dateCreated.compareTo(a!.dateCreated)
                : a!.dateCreated.compareTo(b!.dateCreated);
          case ProjectSortType.byName:
            return isAscending
                ? b!.projectName.compareTo(a!.projectName)
                : a!.projectName.compareTo(b!.projectName);
          default:
            return isAscending
                ? b!.dateCreated.compareTo(a!.dateCreated)
                : a!.dateCreated.compareTo(b!.dateCreated);
        }
      },
    );
  }

  List<ProjectModel?> searchProjects(String searchText) {
    List<ProjectModel?> _foundProjects = [];
    if (searchText.isNotEmpty) {
      _foundProjects = projects
          .where((element) =>
              element!.projectName.toLowerCase().contains(searchText))
          .toList();
    } else {
      _foundProjects = projects;
    }
    return _foundProjects;
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
