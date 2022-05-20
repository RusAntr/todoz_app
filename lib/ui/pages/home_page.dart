import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/ui/pages/archive_page.dart';
import 'package:todoz_app/ui/ui_export.dart';
import '../../core/constants/constants.dart';
import '../widgets/profile_page_menu_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TodoController _todoController;
  late int _pageIndex;
  late DateTime _date;
  late List<Widget> progressWidgets;
  late final PageController _pageController;
  late bool _showAllTodos;
  bool isAscending = false;

  @override
  void initState() {
    _todoController = Get.put(TodoController());
    _date = DateTime.now();
    _showAllTodos = false;
    _pageIndex = 1;
    _pageController = PageController(initialPage: 1, keepPage: true);
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
            _todoCards(),
            const SizedBox(height: 20),
            _inProgressTitleIndicator(),
            inProgressTodoCards(),
          ],
        ),
      ],
    );
  }

  GetX inProgressTodoCards() {
    return GetX<TodoController>(builder: (_todoController) {
      var progressivesList = _todoController.doneUndondeProgressiveTodos(
        _showAllTodos,
        _pageIndex,
        _date,
      );
      return progressivesList.isEmpty
          ? const EmptyTodo()
          : ListView.builder(
              addAutomaticKeepAlives: false,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: progressivesList.length,
              itemBuilder: (_, index) {
                return TodoProgressiveCard(
                  key: Key(progressivesList[index].todoId),
                  todoModel: progressivesList[index],
                );
              },
            );
    });
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
                      .doneUndondeProgressiveTodos(
                          _showAllTodos, _pageIndex, _date)
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
        var undoneTodos = _todoController
            .relevantTodoModels(_date, _pageIndex, _showAllTodos)
            .where((element) => !element.isDone)
            .toList();
        if (undoneTodos.isNotEmpty) {
          return SizedBox(
            height: 150.0,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: undoneTodos.length,
              itemBuilder: (_, index) {
                return TodoCard(
                  todoModel: undoneTodos[index],
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                        .relevantTodoModels(_date, _pageIndex, _showAllTodos)
                        .where((element) => !element.isDone)
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
            onTap: () =>
                setState(() => _showAllTodos = _showAllTodos ? false : true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 25,
              width: _showAllTodos ? 50 : 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.accentGreen),
              child: Center(
                child: Text(
                  !_showAllTodos ? 'all'.tr : 'less'.tr,
                  style: AppTextStyles.textStyleSmallGreenText,
                ),
              ),
            ),
          ),
          PopupMenuButton(
            enableFeedback: true,
            splashRadius: 15,
            tooltip: 'sort'.tr,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            icon: const Icon(
              Icons.filter_list,
              color: Colors.black45,
            ),
            onSelected: _onSelectedItem,
            itemBuilder: (context) => [
              _buildItem(CustomMenuItem(
                  text: 'sortDateCreated'.tr,
                  icon: Icons.calendar_today_outlined,
                  todoSortType: TodoSortType.byDateCreated)),
              _buildItem(CustomMenuItem(
                  text: 'sortDateUntil'.tr,
                  icon: Icons.access_alarm_rounded,
                  todoSortType: TodoSortType.byDateUntil)),
              _buildItem(CustomMenuItem(
                  text: 'sortTimePassed'.tr,
                  icon: Icons.hourglass_empty_rounded,
                  todoSortType: TodoSortType.byTimePassed)),
              _buildItem(CustomMenuItem(
                  text: 'sortDuration'.tr,
                  icon: Icons.schedule_rounded,
                  todoSortType: TodoSortType.byDuration)),
            ],
          )
        ],
      ),
    );
  }

  _onSelectedItem(CustomMenuItem item) {
    setState(() {});
    for (var sortType in TodoSortType.values) {
      item.todoSortType == sortType
          ? _todoController.sort(sortType, isAscending)
          : () {};
    }
    isAscending = isAscending ? false : true;
  }

  PopupMenuItem<CustomMenuItem> _buildItem(CustomMenuItem item) =>
      PopupMenuItem(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 15.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              item.text,
              style: AppTextStyles.dateTimeItem.copyWith(fontSize: 12.0),
            )
          ],
        ),
      );

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
            onPressed: () => Get.to(() => const ArchivePage()),
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
      onPressed: () {
        _todoController.openCreateTodo(context: context, visible: true);
      },
      child: const Icon(
        Icons.add_rounded,
      ),
    );
  }
}
