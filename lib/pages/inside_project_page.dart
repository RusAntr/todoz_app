import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/authController.dart';
import 'package:todoz_app/controllers/projectController.dart';
import 'package:todoz_app/controllers/todoController.dart';
import 'package:todoz_app/models/projectModel.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/tab_picker.dart';
import 'package:todoz_app/widgets/todo_card_in_project_widget.dart';

class InsideProjectPage extends StatefulWidget {
  final ProjectModel projectModel;

  const InsideProjectPage({Key? key, required this.projectModel})
      : super(key: key);

  @override
  State<InsideProjectPage> createState() => _InsideProjectPageState();
}

class _InsideProjectPageState extends State<InsideProjectPage>
    with TickerProviderStateMixin {
  late AuthController _authController;
  late TodoController _todoController;
  late int widgetIndex;

  Widget allTodos(TodoController todoController, ProjectModel projectModel,
      AuthController authController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: todoController.todos
          .where((element) => element!.projectName == projectModel.projectName)
          .length,
      itemBuilder: (_, index) {
        return TodoCardInProjectWidget(
          projectColor: projectModel.color,
          projectName: projectModel.projectName,
          projectId: projectModel.projectId,
          todoModel: todoController.todos
              .where(
                  (element) => element!.projectName == projectModel.projectName)
              .toList()[index]!,
          uid: authController.user!.uid,
        );
      },
    );
  }

  Widget doneTodos(TodoController todoController, ProjectModel projectModel,
      AuthController authController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: todoController.todos
          .where((element) =>
              element!.isDone == true &&
              element.projectName == projectModel.projectName)
          .length,
      itemBuilder: (_, index) {
        return TodoCardInProjectWidget(
          projectColor: projectModel.color,
          projectName: projectModel.projectName,
          projectId: projectModel.projectId,
          todoModel: todoController.todos
              .where((element) =>
                  element!.isDone == true &&
                  element.projectName == projectModel.projectName)
              .toList()[index]!,
          uid: authController.user!.uid,
        );
      },
    );
  }

  Widget undoneTodos(TodoController todoController, ProjectModel projectModel,
      AuthController authController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: todoController.todos
          .where((element) =>
              element!.isDone == false &&
              element.projectName == projectModel.projectName)
          .length,
      itemBuilder: (_, index) {
        return TodoCardInProjectWidget(
          projectColor: projectModel.color,
          projectName: projectModel.projectName,
          projectId: projectModel.projectId,
          todoModel: todoController.todos
              .where((element) =>
                  element!.isDone == false &&
                  element.projectName == projectModel.projectName)
              .toList()[index]!,
          uid: authController.user!.uid,
        );
      },
    );
  }

  @override
  void initState() {
    _authController = Get.find<AuthController>();
    _todoController = Get.find<TodoController>();
    widgetIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int retrivedColor = int.parse(widget.projectModel.color);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        primary: true,
        actions: [
          IconButton(
              onPressed: () {
                ProjectController().openCreateProject(
                    context,
                    widget.projectModel,
                    false,
                    _todoController.todos
                        .where((element) =>
                            element!.projectName ==
                            widget.projectModel.projectName)
                        .toList());
              },
              icon: const Icon(
                EvaIcons.edit2,
                color: Colors.black,
              ))
        ],
        leading: IconButton(
          onPressed: () => Get.back(),
          iconSize: 30,
          icon: const Icon(EvaIcons.arrowBack),
          color: Colors.black,
          splashRadius: 0.1,
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(widget.projectModel.projectName,
            style: Styles().textStyleTitle),
      ),
      floatingActionButton: FloatingActionButton(
          enableFeedback: true,
          splashColor: Color(retrivedColor).withOpacity(0.2),
          hoverElevation: 0,
          highlightElevation: 0,
          hoverColor: Color(retrivedColor).withOpacity(0.2),
          backgroundColor: Color(retrivedColor),
          child: Icon(EvaIcons.plus, color: Colors.white.withOpacity(0.6)),
          onPressed: () => TodoController()
              .openCreateTodo(context, false, widget.projectModel)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabPicker(
            projectColor: widget.projectModel.color,
            projectName: widget.projectModel.projectName,
            initialWidget: widgetIndex,
            availableWidgets: const [1, 2, 3],
            onSelectWidget: (int index) {
              setState(() {
                widgetIndex = index;
              });
            },
          ),
          Expanded(
            child: GetX<TodoController>(
                init: Get.put<TodoController>(TodoController()),
                builder: (TodoController todoController) {
                  if (todoController.isBlank != true &&
                      todoController.todos
                          .where((element) =>
                              element!.projectName ==
                              widget.projectModel.projectName)
                          .isNotEmpty) {
                    return Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: widgetIndex == 1
                            ? allTodos(todoController, widget.projectModel,
                                _authController)
                            : widgetIndex == 2
                                ? undoneTodos(todoController,
                                    widget.projectModel, _authController)
                                : widgetIndex == 3
                                    ? doneTodos(todoController,
                                        widget.projectModel, _authController)
                                    : Container());
                  } else {
                    return const Text('loading');
                  }
                }),
          ),
        ],
      ),
    );
  }
}
