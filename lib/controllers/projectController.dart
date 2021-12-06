// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:todoz_app/controllers/authController.dart';
import 'package:todoz_app/models/projectModel.dart';
import 'package:todoz_app/services/database.dart';

class ProjectController extends GetxController {
  final Rx<List<ProjectModel?>> _projectList = Rx<List<ProjectModel?>>([]);

  List<ProjectModel?> get projects => _projectList.value;

  @override
  onInit() {
    String uid = Get.find<AuthController>().user!.uid;
    _projectList.bindStream(Database().getProjects(uid));
    super.onInit();
  }
}
