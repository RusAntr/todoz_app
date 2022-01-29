import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_selector/item_selector.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/utils/item_selection.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/project_choice_chip.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:date_time_format/src/date_time_extension_methods.dart';

class CreateTodo extends GetWidget<AuthController> {
  CreateTodo({Key? key, required this.visibility, this.projectModel})
      : super(key: key);

  final TextEditingController _todoController = TextEditingController();
  String? chosenProject;
  bool visibility;
  ProjectModel? projectModel;
  DateTime? dateUntil;
  DateTime? duration;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final selection = RectSelection(1);
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Spacer(
                flex: 2,
              ),
              Center(
                child: Text(
                  'newTask'.tr,
                  style: Styles().textStyleAddTaskText,
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.only(right: 5, left: 5)),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.black.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffF2F4F5))),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(
                      EvaIcons.close,
                      color: Colors.black,
                      size: 25,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _todoController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(17),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  filled: true,
                  fillColor: const Color(0xFFEEF1F7),
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  hintText: 'titleHint'.tr,
                  hintStyle: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 15),
          Visibility(
            visible: visibility,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'addToProject'.tr,
                style: Styles().textStyleBlackSmallText,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Visibility(
            visible: visibility,
            child: GetX<ProjectController>(
              init: Get.put<ProjectController>(ProjectController()),
              builder: (ProjectController projectController) {
                if (projectController.isBlank != true &&
                    projectController.projects.isNotEmpty) {
                  return SizedBox(
                    key: key,
                    height: 110,
                    width: width,
                    child: ItemSelectionController(
                        onSelectionStart: selection.start,
                        selection: selection,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () => ProjectController()
                                    .openCreateProject(
                                        context, null, true, null),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  height: 80,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            offset: const Offset(0, 8),
                                            blurRadius: 5,
                                            spreadRadius: 0)
                                      ],
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey[500]),
                                  child: Center(
                                      child: Icon(
                                    EvaIcons.plusSquare,
                                    size: 30,
                                    color: Colors.white.withOpacity(0.5),
                                  )),
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: projectController.projects.length,
                                  itemBuilder: (_, index) {
                                    return ItemSelectionBuilder(
                                        index: index,
                                        builder: (BuildContext context,
                                            int index, bool selected) {
                                          if (selected == true) {
                                            chosenProject = projectController
                                                .projects[index]!.projectName;
                                            projectModel = projectController
                                                .projects[index];
                                          }
                                          return ProjectChoiceChip(
                                            isSelected: selected,
                                            projectModel: projectController
                                                .projects[index],
                                          );
                                        });
                                  }),
                              const SizedBox(width: 15),
                            ],
                          ),
                        )),
                  );
                } else {
                  return Center(
                    child: Text(
                      'noProjects'.tr,
                      style: Styles().textStyleNoProjects,
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                        elevation: MaterialStateProperty.all<double>(50),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () async {
                      dateUntil = await DatePicker.showDateTimePicker(
                        context,
                        locale: LocaleType.ru,
                        currentTime: DateTime.now(),
                        minTime: DateTime(DateTime.now().year - 1),
                        maxTime: DateTime(DateTime.now().year + 1),
                        onConfirm: (date) {
                          dateUntil = date;
                        },
                      );
                    },
                    child: const Icon(
                      EvaIcons.calendarOutline,
                      size: 25,
                      color: Colors.black,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                        elevation: MaterialStateProperty.all<double>(50),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () async {
                      duration = await DatePicker.showTimePicker(
                        context,
                        locale: LocaleType.ru,
                        currentTime: DateTime.now(),
                        onConfirm: (date) {
                          duration = date;
                        },
                      );
                    },
                    child: const Icon(
                      EvaIcons.clockOutline,
                      size: 25,
                      color: Colors.black,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff6E4AFF))),
                    onPressed: () {
                      TodoController().addTodo(
                          projectName:
                              visibility == true && chosenProject != null
                                  ? chosenProject!
                                  : 'NoProject',
                          controller: _todoController,
                          uid: controller.user!.uid,
                          projectId: projectModel == null
                              ? 'NoProject'
                              : projectModel?.projectId,
                          dateUntil: dateUntil,
                          duration: duration);
                    },
                    child: Text(
                      'create'.tr,
                      style: Styles().textStyleProjectChipText,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
