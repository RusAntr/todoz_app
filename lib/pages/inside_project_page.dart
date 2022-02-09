import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/empty_todo_widget.dart';
import 'package:todoz_app/widgets/todo_card_in_project_widget.dart';
import 'package:todoz_app/widgets/todo_progressive_widget.dart';

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
  late ProjectController _projectController;

  @override
  void initState() {
    _projectController = Get.find<ProjectController>();
    _authController = Get.find<AuthController>();
    _todoController = Get.find<TodoController>();
    super.initState();
  }

  ProjectModel get model {
    return _projectController.projects.singleWhere(
        (element) => element!.projectId == widget.projectModel.projectId)!;
  }

  int get howManyDone {
    return _todoController.todos
        .where((element) =>
            element!.projectName == model.projectName && element.isDone == true)
        .length;
  }

  int get howManyUndone {
    return _todoController.todos
        .where((element) =>
            element!.projectName == model.projectName &&
            element.isDone == false)
        .length;
  }

  int get howManyInProgress {
    return _todoController.todos
        .where((element) =>
            element!.projectName == model.projectName &&
            element.duration != null)
        .length;
  }

  Color get projectColor {
    return Color(int.parse(model.color));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Obx(() => TextButton.icon(
          label: Text(
            'newTask'.tr,
            style: Styles.createNewTask,
          ),
          style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.white.withOpacity(.2)),
              elevation: MaterialStateProperty.all(10.0),
              shadowColor:
                  MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
              backgroundColor:
                  MaterialStateProperty.all(Color(int.parse(model.color)))),
          icon: const Icon(
            EvaIcons.plus,
            color: Colors.white,
            size: 20.0,
          ),
          onPressed: () =>
              TodoController().openCreateTodo(context, false, model))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool isSrolled) {
            return [
              SliverAppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                centerTitle: false,
                toolbarHeight: 70.0,
                collapsedHeight: 70.0,
                expandedHeight: 70.0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                        onTap: () => ProjectController().openCreateProject(
                            context,
                            model,
                            false,
                            _todoController.todos
                                .where((element) =>
                                    element!.projectName == model.projectName)
                                .toList()),
                        child: const Icon(
                          EvaIcons.editOutline,
                          size: 30.0,
                          color: Colors.black,
                        )),
                  )
                ],
                title: Obx(() =>
                    Text(model.projectName, style: Styles.textStyleTitle)),
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(EvaIcons.arrowBack,
                      color: Colors.black, size: 30.0),
                ),
                pinned: false,
                snap: false,
                floating: true,
              ),
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: MySliverPersistentHeaderDelegate(Obx(() => Theme(
                      data: ThemeData(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent),
                      child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        isScrollable: true,
                        padding: const EdgeInsets.only(bottom: 10.0),
                        labelColor: Colors.white,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelColor: projectColor,
                        unselectedLabelStyle: Styles.textStyleSmallGreenText,
                        labelStyle: Styles.textStyleSmallGreenText,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: projectColor),
                        tabs: [
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Color(int.parse(model.color))
                                    .withOpacity(.1),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('all'.tr.capitalize! +
                                    "    " +
                                    _todoController.todos
                                        .where((element) =>
                                            element!.projectName ==
                                            model.projectName)
                                        .length
                                        .toString()),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Color(int.parse(model.color))
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('done'.tr.capitalize! +
                                    "    " +
                                    howManyDone.toString()),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Color(int.parse(model.color))
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('taskUndone'.tr.capitalizeFirst! +
                                    "    " +
                                    howManyUndone.toString()),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Color(int.parse(model.color))
                                    .withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('inProgress'.tr.capitalizeFirst! +
                                    "    " +
                                    howManyInProgress.toString()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
              ),
            ];
          },
          body: Obx(() => TabBarView(children: [
                allTodos(_todoController, model, _authController),
                doneTodos(_todoController, model, _authController),
                undoneTodos(_todoController, model, _authController),
                inProgressTodos(_todoController, model, _authController)
              ])),
        ),
      ),
    ));
  }

  Widget allTodos(TodoController todoController, ProjectModel projectModel,
      AuthController authController) {
    if (todoController.todos
        .where((element) => element!.projectName == projectModel.projectName)
        .isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: todoController.todos
            .where(
                (element) => element!.projectName == projectModel.projectName)
            .length,
        itemBuilder: (_, index) {
          return TodoCardInProjectWidget(
            projectColor: projectModel.color,
            projectName: projectModel.projectName,
            projectId: projectModel.projectId,
            todoModel: todoController.todos
                .where((element) =>
                    element!.projectName == projectModel.projectName)
                .toList()[index]!,
            uid: authController.user!.uid,
          );
        },
      );
    } else {
      return const EmptyTodoWidget();
    }
  }

  Widget doneTodos(TodoController todoController, ProjectModel projectModel,
      AuthController authController) {
    if (todoController.todos
        .where((element) =>
            element!.isDone == true &&
            element.projectName == projectModel.projectName)
        .isNotEmpty) {
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
    } else {
      return const EmptyTodoWidget();
    }
  }

  Widget undoneTodos(TodoController todoController, ProjectModel projectModel,
      AuthController authController) {
    if (todoController.todos
        .where((element) =>
            element!.isDone == false &&
            element.projectName == projectModel.projectName)
        .isNotEmpty) {
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
    } else {
      return const EmptyTodoWidget();
    }
  }
}

Widget inProgressTodos(TodoController todoController, ProjectModel projectModel,
    AuthController authController) {
  if (todoController.todos
      .where((element) =>
          element!.duration != null &&
          element.projectName == projectModel.projectName &&
          element.isDone == false)
      .isNotEmpty) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: todoController.todos
          .where((element) =>
              element!.duration != null &&
              element.projectName == projectModel.projectName &&
              element.isDone == false)
          .length,
      itemBuilder: (_, index) {
        return TodoProgressiveWidget(
          todoModel: todoController.todos
              .where((element) =>
                  element!.duration != null &&
                  element.projectName == projectModel.projectName &&
                  element.isDone == false)
              .toList()[index]!,
          uid: authController.user!.uid,
        );
      },
    );
  } else {
    return const EmptyTodoWidget();
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
