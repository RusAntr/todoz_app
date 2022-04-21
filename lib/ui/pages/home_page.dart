import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/ui/pages/archive_page.dart';
import 'package:todoz_app/ui/ui_export.dart';
import '../../core/constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TodoController _todoController;
  late ProjectController _projectController;
  late int _pageIndex;
  late DateTime _date;
  late List<Widget> progressWidgets;
  late final PageController _pageController;
  late bool _showAllTodos;

  @override
  void initState() {
    _todoController = Get.put(TodoController());
    _projectController = Get.put(ProjectController());
    _date = DateTime.now();
    _showAllTodos = false;
    _pageIndex = 1;
    _pageController = PageController(initialPage: 1, keepPage: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressWidgets = [
      ProgressWidget(
          day: 'yesterday',
          dateTime: _date.subtract(const Duration(days: 1)),
          areAllTasks: _showAllTodos),
      ProgressWidget(
        day: 'today',
        dateTime: _date,
        areAllTasks: _showAllTodos,
      ),
      ProgressWidget(
        day: 'tomorrow',
        dateTime: _date.add(
          const Duration(days: 1),
        ),
        areAllTasks: _showAllTodos,
      )
    ];
    final height = Get.height;
    final width = Get.width;
    return Scaffold(
      floatingActionButton: _addTodoFAB(),
      backgroundColor: Colors.white,
      body: _bodyList(height, width),
    );
  }

  Widget _bodyList(double _height, double _width) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _kindOfAppBar(),
            _progressWidgets(_width, _height),
            const SizedBox(height: 7),
            PageViewIndicators(pageIndex: _pageIndex),
            _todoTitleIndicator(),
            const SizedBox(height: 20),
            _todoCards(),
            const SizedBox(height: 20),
            _inProgressTitleIndicator(),
            inProgressCards(),
          ],
        ),
      ],
    );
  }

  Widget inProgressCards() {
    return Obx(
      () => _todoController.doneUndondeProgressiveTodos(_showAllTodos).isEmpty
          ? const EmptyTodo()
          : ListView.builder(
              addAutomaticKeepAlives: false,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _todoController
                  .doneUndondeProgressiveTodos(_showAllTodos)
                  .length,
              itemBuilder: (_, index) {
                return TodoProgressiveCard(
                  key: Key(_todoController
                      .doneUndondeProgressiveTodos(_showAllTodos)[index]
                      .todoId),
                  todoModel: _todoController
                      .doneUndondeProgressiveTodos(_showAllTodos)[index],
                );
              },
            ),
    );
  }

  Widget _inProgressTitleIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'inProgress'.tr,
            style: AppTextStyles.textStyleBlackBigText,
          ),
          const SizedBox(width: 10.0),
          Container(
            height: 25.0,
            width: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: AppColors.accentRed),
            child: Center(
              child: Obx(
                () => Text(
                  _todoController
                      .doneUndondeProgressiveTodos(_showAllTodos)
                      .length
                      .toString(),
                  style: AppTextStyles.textStyleSmallRedText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _todoCards() {
    return GetX<TodoController>(
      builder: (_) {
        if (_todoController
            .relevantTodoModels(
              _date,
              _pageIndex,
              _showAllTodos,
            )
            .where((element) => element.isDone == false)
            .toList()
            .isNotEmpty) {
          return SizedBox(
            height: 150.0,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _todoController
                  .relevantTodoModels(
                    _date,
                    _pageIndex,
                    _showAllTodos,
                  )
                  .where((element) => element.isDone == false)
                  .length,
              itemBuilder: (_, index) {
                return TodoCard(
                  todoModel: _todoController
                      .relevantTodoModels(
                        _date,
                        _pageIndex,
                        _showAllTodos,
                      )
                      .where((element) => element.isDone == false)
                      .toList()[index],
                );
              },
            ),
          );
        } else {
          return const EmptyTodo();
        }
      },
    );
  }

  Widget _todoTitleIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'toDo'.tr,
            style: AppTextStyles.textStyleBlackBigText,
          ),
          const SizedBox(width: 10),
          Container(
            height: 25.0,
            width: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: AppColors.accentGreen),
            child: Center(
              child: GetX<TodoController>(
                builder: (_) {
                  return Text(
                    _todoController
                        .relevantTodoModels(
                          _date,
                          _pageIndex,
                          _showAllTodos,
                        )
                        .where((element) => element.isDone == false)
                        .length
                        .toString(),
                    style: AppTextStyles.textStyleSmallGreenText,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  if (_showAllTodos == false) {
                    _showAllTodos = true;
                  } else if (_showAllTodos == true) {
                    _showAllTodos = false;
                  }
                },
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 25,
              width: _showAllTodos == true ? 50 : 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.accentGreen),
              child: Center(
                child: Text(
                  _showAllTodos == false ? 'all'.tr : 'less'.tr,
                  style: AppTextStyles.textStyleSmallGreenText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressWidgets(double _width, double _height) {
    return SizedBox(
      width: _width,
      height: _height / 5,
      child: PageView(
        pageSnapping: true,
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: progressWidgets,
        onPageChanged: (int index) => setState(() => _pageIndex = index),
      ),
    );
  }

  Widget _kindOfAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GetX<UserController>(
            initState: (_) async => Get.find<UserController>(),
            builder: (UserController userController) {
              if (userController.userModel.name != null) {
                return Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'hello'.trArgs([userController.userModel.name!]),
                      maxLines: 1,
                      style: AppTextStyles.textStyleTitle,
                    ),
                  ),
                );
              } else {
                return Text(
                  'loading',
                  style: AppTextStyles.textStyleTitle,
                );
              }
            },
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(EvaIcons.archiveOutline),
            iconSize: 30,
            onPressed: () => Get.to(() => ArchivePage()),
          )
        ],
      ),
    );
  }

  FloatingActionButton _addTodoFAB() {
    return FloatingActionButton(
      hoverElevation: 10.0,
      hoverColor: AppColors.darkPurple,
      splashColor: AppColors.darkPurple,
      elevation: 30.0,
      backgroundColor: AppColors.mainPurple,
      onPressed: () => _todoController.openCreateTodo(
        context,
        true,
        _projectController.projects.first,
      ),
      child: const Icon(
        Icons.add_rounded,
      ),
    );
  }
}
