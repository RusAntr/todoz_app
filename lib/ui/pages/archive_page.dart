import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/ui/widgets/search_bar.dart';
import '../../core/constants/constants.dart';
import '../ui_export.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final _projectController = Get.find<ProjectController>();
  final _todoController = Get.find<TodoController>();
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  GetX<TodoController> _body() {
    return GetX<TodoController>(
      builder: (TodoController todoController) {
        var foundTodos =
            _todoController.searchTodos(_textEditingController.text);
        return foundTodos.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: foundTodos.length,
                itemBuilder: (_, index) {
                  var todo = foundTodos[index];
                  if (foundTodos.isEmpty) {
                    return const EmptyTodo();
                  } else {
                    return Obx(
                      () => TodoCardInProject(
                        todoModel: todo!,
                        projectColor: '0xff6666FF',
                        projectId:
                            _projectController.getProjectId(foundTodos[index]!),
                      ),
                    );
                  }
                },
              )
            : const EmptyTodo();
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 70.0,
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Row(
        children: [
          Text(
            'archive'.tr,
            style: AppTextStyles.textStyleTitle,
          ),
        ],
      ),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          EvaIcons.arrowBack,
          size: 30,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15, right: 9),
          child: SearchBar(
            textEditingController: _textEditingController,
            onChanged: (value) =>
                setState(() => _todoController.searchTodos(value)),
          ),
        ),
      ],
    );
  }
}
