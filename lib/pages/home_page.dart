import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/page_view_indicators.dart';
import 'package:todoz_app/widgets/progress_widget.dart';
import 'package:todoz_app/widgets/todo_card_widget.dart';
import 'package:todoz_app/widgets/todo_progressive_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthController authController = Get.find<AuthController>();
  late TodoController todoController;
  late int _pageIndex;
  late DateTime _date;
  late List<Widget> _progressWidgets;
  late final PageController _pageController;
  late bool _showAllTodos;
  late ProjectController vv;

  @override
  void initState() {
    vv = Get.put<ProjectController>(ProjectController());
    todoController = Get.put<TodoController>(TodoController());

    _date = DateTime.now();
    _showAllTodos = false;
    _pageIndex = 1;
    _pageController = PageController(initialPage: 1, keepPage: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _progressWidgets = [
      ProgressWidget(
          day: 'yesterday',
          dateTime: _date.subtract(const Duration(days: 1)),
          areAllTasks: _showAllTodos),
      ProgressWidget(day: 'today', dateTime: _date, areAllTasks: _showAllTodos),
      ProgressWidget(
          day: 'tomorrow',
          dateTime: _date.add(const Duration(days: 1)),
          areAllTasks: _showAllTodos)
    ];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //USERNAME
                  GetX<UserController>(initState: (_) async {
                    Get.find<UserController>().userModel = await Database()
                        .getUser(Get.find<AuthController>().user!.uid);
                  }, builder: (userController) {
                    if (userController.userModel.email != null) {
                      return Text(
                          'hello'.trArgs(
                              [userController.userModel.name.toString()]),
                          style: Styles().textStyleTitle);
                    } else {
                      return Text('loading', style: Styles().textStyleTitle);
                    }
                  }),
                  //ARCHIVE BUTTON
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(EvaIcons.archiveOutline),
                    iconSize: 30,
                    onPressed: () {},
                  )
                ],
              ),
            ),
            SizedBox(height: height / 40),
            SizedBox(
              width: width,
              height: height / 5,
              child: PageView(
                pageSnapping: true,
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                children: _progressWidgets,
                onPageChanged: (int index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 7),
            PageViewIndicators(pageIndex: _pageIndex),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('toDo'.tr, style: Styles().textStyleBlackBigText),
                  const SizedBox(width: 10),
                  //INDICATOR
                  Container(
                    height: 25,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xFFDFFFD4)),
                    child: Center(
                      child: GetX<TodoController>(
                          init: Get.put<TodoController>(TodoController()),
                          builder: (TodoController todoController) {
                            return Text(
                              TodoController()
                                  .relevantTodoModels(todoController, _date,
                                      _pageIndex, _showAllTodos)
                                  .where((element) => element.isDone == false)
                                  .length
                                  .toString(),
                              style: Styles().textStyleSmallGreenText,
                            );
                          }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_showAllTodos == false) {
                          _showAllTodos = true;
                        } else if (_showAllTodos == true) {
                          _showAllTodos = false;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 25,
                      width: _showAllTodos == true ? 50 : 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: const Color(0xFFDFFFD4)),
                      child: Center(
                        child: Text(
                          _showAllTodos == false ? 'all'.tr : 'less'.tr,
                          style: Styles().textStyleSmallGreenText,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height / 80),
            GetX<TodoController>(
                init: Get.put<TodoController>(TodoController()),
                builder: (TodoController todoController) {
                  if (todoController.todos.isNotEmpty &&
                      TodoController()
                          .relevantTodoModels(
                              todoController, _date, _pageIndex, _showAllTodos)
                          .where((element) => element.isDone == false)
                          .toList()
                          .isNotEmpty) {
                    return SizedBox(
                      height: height / 5,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: TodoController()
                              .relevantTodoModels(todoController, _date,
                                  _pageIndex, _showAllTodos)
                              .where((element) => element.isDone == false)
                              .length,
                          itemBuilder: (_, index) {
                            return TodoCard(
                              uid: authController.user!.uid,
                              todoModel: TodoController()
                                  .relevantTodoModels(todoController, _date,
                                      _pageIndex, _showAllTodos)
                                  .where((element) => element.isDone == false)
                                  .toList()[index],
                            );
                          }),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                          child: Text('noTasksToDo'.tr,
                              style: Styles().noTasksToDo)),
                    );
                  }
                }),
            SizedBox(height: height / 80),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('inProgress'.tr, style: Styles().textStyleBlackBigText),
                  const SizedBox(width: 10),
                  Container(
                    height: 25,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xFFFFD4D4)),
                    child: Center(
                      child: GetX<TodoController>(
                          init: Get.put<TodoController>(TodoController()),
                          builder: (TodoController todoController) {
                            if (todoController.todos.isNotEmpty) {}
                            return Text(
                              TodoController()
                                  .relevantTodoModels(
                                      todoController, _date, _pageIndex, true)
                                  .where((element) => element.duration != null)
                                  .length
                                  .toString(),
                              style: Styles().textStyleSmallRedText,
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height / 80),
            Obx(() => ListView.builder(
                  addAutomaticKeepAlives: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: todoController.todos
                      .where((element) => element!.duration != null)
                      .toList()
                      .length,
                  itemBuilder: (_, index) {
                    return TodoProgressiveWidget(
                      key: Key(todoController.todos
                          .where((element) => element!.duration != null)
                          .toList()[index]!
                          .todoId),
                      uid: authController.user!.uid,
                      todoModel: todoController.todos
                          .where((element) => element!.duration != null)
                          .toList()[index]!,
                    );
                  },
                )),
            // ElevatedButton(
            //   child: const Text('sign out'),
            //   onPressed: () {
            //     authController.signOut();
            //   },
            // ),
          ],
        ),
      ],
    );
  }
}
