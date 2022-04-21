import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import '../../core/constants/constants.dart';
import '../ui_export.dart';

class ArchivePage extends GetWidget<TodoController> {
  ArchivePage({Key? key}) : super(key: key);
  final _projectController = Get.find<ProjectController>();
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
            style: AppTextStyles.textStyleTitle,
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
        body: GetX<TodoController>(
          builder: (_) {
            var _modelsList = controller.todos
                .where((element) => element!.isDone == true)
                .toList();
            return _modelsList.isEmpty
                ? const EmptyTodo()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.howManyTasksDoneProgress(null, true),
                    itemBuilder: (context, index) {
                      if (_modelsList.isEmpty) {
                        return const EmptyTodo();
                      } else {
                        return Obx(
                          () => TodoCardInProject(
                            todoModel: _modelsList[index]!,
                            projectColor: '0xff6666FF',
                            projectId: _projectController
                                .getProjectId(_modelsList[index]!),
                          ),
                        );
                      }
                    },
                  );
          },
        ),
      ),
    );
  }
}
