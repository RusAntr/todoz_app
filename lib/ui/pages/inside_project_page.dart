import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import '../../core/constants/constants.dart';
import '../../data/models/models.dart';
import '../ui_export.dart';

class InsideProjectPage extends StatefulWidget {
  final ProjectModel projectModel;
  const InsideProjectPage({
    Key? key,
    required this.projectModel,
  }) : super(key: key);

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

  ProjectModel get _projectModel {
    return _projectController.projects.singleWhere(
        (element) => element!.projectId == widget.projectModel.projectId)!;
  }

  int get _howManyDone {
    return _todoController.todos
        .where((element) =>
            element!.projectName == _projectModel.projectName && element.isDone)
        .length;
  }

  int get _howManyUndone {
    return _todoController.todos
        .where((element) =>
            element!.projectName == _projectModel.projectName &&
            !element.isDone)
        .length;
  }

  int get _howManyInProgress {
    return _todoController.todos
        .where((element) =>
            element!.projectName == _projectModel.projectName &&
            element.duration != null &&
            !element.isDone)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: _newTaskFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (
              BuildContext context,
              bool isSrolled,
            ) {
              return [
                _sliverAppBar(),
                _sliverPersistentHeader(),
              ];
            },
            body: Obx(
              () => TabBarView(
                children: [
                  _allTodos(_projectModel, _authController),
                  _doneTodos(_projectModel, _authController),
                  _undoneTodos(_projectModel, _authController),
                  _inProgressTodos(_projectModel, _authController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: MySliverPersistentHeaderDelegate(
        Obx(
          () => Theme(
            data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: Center(
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                isScrollable: true,
                padding: const EdgeInsets.only(bottom: 10.0),
                labelColor: Colors.white,
                labelPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: AppColors().getColor(_projectModel.color),
                unselectedLabelStyle: AppTextStyles.textStyleSmallGreenText,
                labelStyle: AppTextStyles.textStyleSmallGreenText,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors().getColor(_projectModel.color),
                ),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors()
                            .getColor(_projectModel.color)
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
                                    _projectModel.projectName)
                                .length
                                .toString()),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors()
                            .getColor(_projectModel.color)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'done'.tr.capitalize! +
                              "    " +
                              _howManyDone.toString(),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors()
                            .getColor(_projectModel.color)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'taskUndone'.tr.capitalizeFirst! +
                              "    " +
                              _howManyUndone.toString(),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors()
                            .getColor(_projectModel.color)
                            .withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'inProgress'.tr.capitalizeFirst! +
                              "    " +
                              _howManyInProgress.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      centerTitle: false,
      toolbarHeight: 70.0,
      collapsedHeight: 70.0,
      expandedHeight: 70.0,
      actions: [_changeButton()],
      title: Obx(
        () => Text(
          _projectModel.projectName,
          style: AppTextStyles.textStyleTitle,
        ),
      ),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          EvaIcons.arrowBack,
          color: Colors.black,
          size: 30.0,
        ),
      ),
      pinned: false,
      snap: false,
      floating: true,
    );
  }

  Widget _changeButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: () => _projectController.openCreateProject(
            context: context,
            projectModel: _projectModel,
            isCreate: false,
            todoModels: _todoController.todos
                .where((element) =>
                    element!.projectName == _projectModel.projectName)
                .toList()),
        child: const Icon(
          EvaIcons.editOutline,
          size: 30.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _newTaskFAB() {
    return Obx(
      () => TextButton.icon(
        label: Text(
          'newTask'.tr,
          style: AppTextStyles.createNewTask,
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(.2),
          ),
          elevation: MaterialStateProperty.all(10.0),
          shadowColor: MaterialStateProperty.all(
            Colors.black.withOpacity(0.3),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(15.0),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors().getColor(_projectModel.color),
          ),
        ),
        icon: const Icon(
          EvaIcons.plus,
          color: Colors.white,
          size: 20.0,
        ),
        onPressed: () => TodoController().openCreateTodo(
          context: context,
          visible: false,
          projectModel: widget.projectModel,
        ),
      ),
    );
  }

  Widget _allTodos(
    ProjectModel projectModel,
    AuthController authController,
  ) {
    if (_todoController
        .todosInProject(projectModel.projectName, null)
        .isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _todoController
            .todosInProject(projectModel.projectName, null)
            .length,
        itemBuilder: (_, index) {
          return TodoCardInProject(
            projectColor: projectModel.color,
            projectId: projectModel.projectId,
            todoModel: _todoController.todosInProject(
                projectModel.projectName, null)[index],
          );
        },
      );
    } else {
      return const EmptyTodo();
    }
  }

  Widget _doneTodos(
    ProjectModel projectModel,
    AuthController authController,
  ) {
    if (_todoController
        .todosInProject(projectModel.projectName, true)
        .isNotEmpty) {
      return ListView.builder(
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _todoController
            .todosInProject(projectModel.projectName, true)
            .length,
        itemBuilder: (_, index) {
          return TodoCardInProject(
            projectColor: projectModel.color,
            projectId: projectModel.projectId,
            todoModel: _todoController.todosInProject(
                projectModel.projectName, true)[index],
          );
        },
      );
    } else {
      return const EmptyTodo();
    }
  }

  Widget _undoneTodos(
    ProjectModel projectModel,
    AuthController authController,
  ) {
    if (_todoController
        .todosInProject(projectModel.projectName, false)
        .isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _todoController
            .todosInProject(
              projectModel.projectName,
              false,
            )
            .length,
        itemBuilder: (_, index) {
          return TodoCardInProject(
            projectColor: projectModel.color,
            projectId: projectModel.projectId,
            todoModel: _todoController.todosInProject(
                projectModel.projectName, false)[index],
          );
        },
      );
    } else {
      return const EmptyTodo();
    }
  }

  Widget _inProgressTodos(
    ProjectModel projectModel,
    AuthController authController,
  ) {
    if (_todoController
        .todosInProject(projectModel.projectName, false)
        .where((element) => element.duration != null)
        .isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _todoController
            .todosInProject(projectModel.projectName, false)
            .where((element) => element.duration != null)
            .length,
        itemBuilder: (_, index) {
          return TodoProgressiveCard(
            key: Key(_todoController
                .todosInProject(projectModel.projectName, false)[index]
                .todoId),
            todoModel: _todoController
                .todosInProject(projectModel.projectName, false)
                .where((element) => element.duration != null)
                .toList()[index],
          );
        },
      );
    } else {
      return const EmptyTodo();
    }
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
