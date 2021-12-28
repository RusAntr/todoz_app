import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/authController.dart';
import 'package:todoz_app/controllers/todoController.dart';
import 'package:todoz_app/controllers/userController.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/today_progress_widget.dart';
import 'package:todoz_app/widgets/todoCard.dart';

class Home extends GetWidget<AuthController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  }, builder: (_) {
                    if (_.userModel.email != null) {
                      return Text('hello'.trArgs([_.userModel.name.toString()]),
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
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TodayProgressWidget(),
            ),
            SizedBox(height: height / 40),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('toDo'.tr, style: Styles().textStyleBlackBigText),
                  const SizedBox(width: 10),
                  //INDICATOR
                  Container(
                    height: height / 30,
                    width: width / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xFFDFFFD4)),
                    child: Center(
                      child: GetX<TodoController>(
                          init: Get.put<TodoController>(TodoController()),
                          builder: (TodoController todoController) {
                            return Text(
                              todoController.todos
                                  .where((element) => element!.isDone == false)
                                  .length
                                  .toString(),
                              style: Styles().textStyleSmallGreenText,
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height / 80),
            GetX<TodoController>(
                init: Get.put<TodoController>(TodoController()),
                builder: (TodoController todoController) {
                  if (todoController.isBlank != null &&
                      todoController.todos.isNotEmpty) {
                    return SizedBox(
                      height: height / 5,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: todoController.todos.length,
                          itemBuilder: (_, index) {
                            return TodoCard(
                              uid: controller.user!.uid,
                              todoModel: todoController.todos[index]!,
                            );
                          }),
                    );
                  } else {
                    return Text('loading', style: Styles().textStyleTitle);
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
                    height: height / 30,
                    width: width / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xFFFFD4D4)),
                    child: Center(
                      child: GetX<TodoController>(
                          init: Get.put<TodoController>(TodoController()),
                          builder: (TodoController todoController) {
                            if (todoController.isBlank != null &&
                                todoController.todos.isNotEmpty) {
                            } else {}
                            return Text(
                              todoController.todos.length.toString(),
                              style: Styles().textStyleSmallRedText,
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
            // Card(
            //     child: Row(
            //   children: [
            //     Expanded(
            //         child: TextFormField(
            //       controller: _projectController,
            //       decoration: InputDecoration(),
            //     )),
            //     IconButton(
            //         onPressed: () {
            //           if (_projectController.text != "") {
            //             Database().addProject(
            //                 projectName: _projectController.text,
            //                 uid: controller.user!.uid);
            //           } else {
            //             Get.snackbar('Error', 'Error 2',
            //                 snackPosition: SnackPosition.BOTTOM);
            //           }
            //         },
            //         icon: const Icon(Icons.add))
            //   ],
            // )),
            ElevatedButton(
              child: const Text('sign out'),
              onPressed: () {
                controller.signOut();
              },
            ),
          ],
        ),
      ],
    );
  }
}
