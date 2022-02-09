import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/todo_card_in_project_widget.dart';

class ArchivePage extends GetWidget<TodoController> {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'archive'.tr,
          style: Styles.textStyleTitle,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            EvaIcons.arrowBack,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.howManyTasksDone(null, true),
            itemBuilder: (context, index) {
              var _modelsList = controller.todos
                  .where((element) => element!.isDone == true)
                  .toList();

              return Obx(() => TodoCardInProjectWidget(
                  todoModel: _modelsList[index]!,
                  uid: Get.find<AuthController>().user!.uid,
                  projectName: _modelsList[index]!.projectName,
                  projectColor: '0xff6666FF',
                  projectId:
                      ProjectController.getProjectId(_modelsList[index]!)));
            },
          )),
    ));
  }
}
