import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/pages/archive_page.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/empty_todo_widget.dart';
import 'package:todoz_app/widgets/page_view_indicators.dart';
import 'package:todoz_app/widgets/progress_widget.dart';
import 'package:todoz_app/widgets/todo_card_widget.dart';
import 'package:todoz_app/widgets/todo_progressive_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthController _authController;
  late TodoController _todoController;
  late int _pageIndex;
  late DateTime _date;
  late List<Widget> _progressWidgets;
  late final PageController _pageController;
  late bool _showAllTodos;

  @override
  void initState() {
    _authController = Get.find<AuthController>();
    _todoController = Get.put(TodoController());
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
    final _height = Get.height;
    final _width = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, .0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // USERNAME
                    GetX<UserController>(initState: (_) async {
                      Get.find<UserController>().userModel = await Database()
                          .getUser(Get.find<AuthController>().user!.uid);
                    }, builder: (UserController userController) {
                      if (userController.userModel.name != null) {
                        return Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Text(
                                'hello'
                                    .trArgs([userController.userModel.name!]),
                                maxLines: 1,
                                style: Styles.textStyleTitle),
                          ),
                        );
                      } else {
                        return Text('loading', style: Styles.textStyleTitle);
                      }
                    }),
                    //ARCHIVE BUTTON
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(EvaIcons.archiveOutline),
                      iconSize: 30,
                      onPressed: () => Get.to(() => const ArchivePage()),
                    )
                  ],
                ),
              ),
              SizedBox(height: _height / 40),
              SizedBox(
                width: _width,
                height: _height / 5,
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
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('toDo'.tr, style: Styles.textStyleBlackBigText),
                    const SizedBox(width: 10),
                    //INDICATOR
                    Container(
                      height: 25.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: const Color(0xFFDFFFD4)),
                      child: Center(
                        child: GetX<TodoController>(
                            init: Get.put<TodoController>(TodoController()),
                            builder: (TodoController todoController) {
                              return Text(
                                todoController
                                    .relevantTodoModels(
                                        _date, _pageIndex, _showAllTodos)
                                    .where((element) => element.isDone == false)
                                    .length
                                    .toString(),
                                style: Styles.textStyleSmallGreenText,
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
                            style: Styles.textStyleSmallGreenText,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: _height / 80),
              GetX<TodoController>(
                  init: Get.put<TodoController>(TodoController()),
                  builder: (TodoController todoController) {
                    if (todoController
                        .relevantTodoModels(_date, _pageIndex, _showAllTodos)
                        .where((element) => element.isDone == false)
                        .toList()
                        .isNotEmpty) {
                      return SizedBox(
                        height: 160.0,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: todoController
                                .relevantTodoModels(
                                    _date, _pageIndex, _showAllTodos)
                                .where((element) => element.isDone == false)
                                .length,
                            itemBuilder: (_, index) {
                              return TodoCard(
                                uid: _authController.user!.uid,
                                todoModel: todoController
                                    .relevantTodoModels(
                                        _date, _pageIndex, _showAllTodos)
                                    .where((element) => element.isDone == false)
                                    .toList()[index],
                              );
                            }),
                      );
                    } else {
                      return const EmptyTodoWidget();
                    }
                  }),
              SizedBox(height: _height / 80.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('inProgress'.tr, style: Styles.textStyleBlackBigText),
                    const SizedBox(width: 10.0),
                    Container(
                      height: 25.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: const Color(0xFFFFD4D4)),
                      child: Center(
                        child: Obx(() => Text(
                              _todoController
                                  .relevantTodoModels(_date, _pageIndex, true)
                                  .where((element) =>
                                      element.duration != null &&
                                      element.isDone == false)
                                  .length
                                  .toString(),
                              style: Styles.textStyleSmallRedText,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Obx(() => _todoController.todos
                      .where((element) => element!.duration != null)
                      .isEmpty
                  ? const EmptyTodoWidget()
                  : ListView.builder(
                      addAutomaticKeepAlives: false,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: _todoController.todos
                          .where((element) => element!.duration != null)
                          .toList()
                          .length,
                      itemBuilder: (_, index) {
                        return TodoProgressiveWidget(
                          key: Key(_todoController.todos
                              .where((element) => element!.duration != null)
                              .toList()[index]!
                              .todoId),
                          uid: _authController.user!.uid,
                          todoModel: _todoController.todos
                              .where((element) => element!.duration != null)
                              .toList()[index]!,
                        );
                      },
                    )),
            ],
          ),
        ],
      ),
    );
  }
}
