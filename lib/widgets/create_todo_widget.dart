import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoz_app/widgets/project_picker.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key, required this.visibility, this.projectModel})
      : super(key: key);
  final bool visibility;
  final ProjectModel? projectModel;

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  ProjectModel? _pickedProject;
  ProjectModel? _initialProject;
  DateTime? _dateUntil;
  DateTime? _duration;
  final TextEditingController _textEditingController = TextEditingController();
  late AuthController _authController;

  List<ProjectModel?> get _projectModels {
    ProjectController projectController = Get.find<ProjectController>();
    List<ProjectModel?> projects = projectController.projects;
    return projects;
  }

  LocaleType get localeType {
    if (Get.deviceLocale == const Locale('en', 'US')) {
      return LocaleType.en;
    } else if (Get.deviceLocale == const Locale('ru', 'RU')) {
      return LocaleType.ru;
    } else if (Get.deviceLocale == const Locale('zh', 'CN')) {
      return LocaleType.zh;
    } else {
      return LocaleType.en;
    }
  }

  @override
  void initState() {
    if (_projectModels.isNotEmpty) {
      _pickedProject = _projectModels[0];
    }
    _authController = Get.find<AuthController>();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20.0,
              ),
              const Spacer(
                flex: 2,
              ),
              Center(
                child: Text(
                  'newTask'.tr,
                  style: Styles.textStyleAddTaskText,
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: TextButton(
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(20.0, 20.0)),
                        overlayColor: MaterialStateProperty.all(
                            Colors.black.withOpacity(0.1)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xffF2F4F5))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Icon(
                      EvaIcons.close,
                      color: Colors.black.withOpacity(0.5),
                      size: 20.0,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(17.0),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: .0),
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: .0),
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                  filled: true,
                  fillColor: const Color(0xFFEEF1F7),
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: .0),
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                  hintText: 'titleHint'.tr,
                  hintStyle: const TextStyle(fontSize: 16.0)),
            ),
          ),
          const SizedBox(height: 15.0),
          Visibility(
            visible: widget.visibility,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'addToProject'.tr,
                style: Styles.textStyleBlackSmallText,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Visibility(
            visible: widget.visibility,
            child: GetX<ProjectController>(
              init: Get.find<ProjectController>(),
              builder: (ProjectController projectController) {
                if (projectController.projects.isNotEmpty) {
                  _initialProject = _projectModels[0];
                  return SizedBox(
                    height: 100.0,
                    width: width,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: ProjectPicker(
                        onSelectProject: (ProjectModel model) {
                          setState(() {
                            _pickedProject = model;
                          });
                        },
                        initialProject: _initialProject,
                        availableProjects: _projectModels,
                      ),
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 15.0),
                      GestureDetector(
                        onTap: () => ProjectController()
                            .openCreateProject(context, null, true, null),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          height: 90.0,
                          width: 95.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey[500]),
                          child: Center(
                              child: Icon(
                            EvaIcons.plusSquare,
                            size: 30.0,
                            color: Colors.white.withOpacity(0.5),
                          )),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(16.0),
                        shadowColor: MaterialStateProperty.all(
                            Colors.black.withOpacity(0.2)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () async {
                      _dateUntil = await DatePicker.showDateTimePicker(
                        context,
                        locale: localeType,
                        currentTime: DateTime.now(),
                        theme: DatePickerTheme(itemStyle: Styles.dateTimeItem),
                        minTime: DateTime(DateTime.now().year - 1),
                        maxTime: DateTime(DateTime.now().year + 1),
                        onConfirm: (date) {
                          _dateUntil = date;
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          EvaIcons.calendarOutline,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 5.0),
                        Text('date'.tr, style: Styles.dateTimeItem),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(16.0),
                        shadowColor: MaterialStateProperty.all(
                            Colors.black.withOpacity(0.2)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () async {
                      _duration = await DatePicker.showTimePicker(
                        context,
                        theme: DatePickerTheme(itemStyle: Styles.dateTimeItem),
                        locale: localeType,
                        currentTime:
                            DateTime(DateTime.now().year, 0, 0, 0, 0, 0, 0, 0),
                        onConfirm: (date) {
                          _duration = date;
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          EvaIcons.clockOutline,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 5.0),
                        Text('duration'.tr, style: Styles.dateTimeItem),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff6E4AFF))),
                    onPressed: () {
                      TodoController().addTodo(
                          projectName: widget.visibility == true
                              ? _pickedProject!.projectName
                              : widget.projectModel!.projectName,
                          controller: _textEditingController,
                          uid: _authController.user!.uid,
                          projectId: widget.visibility == true
                              ? _pickedProject!.projectId
                              : widget.projectModel!.projectId,
                          dateUntil:
                              _dateUntil.isBlank == true ? null : _dateUntil,
                          duration: _duration == null ||
                                  (_duration!.hour == 0 &&
                                      _duration!.minute == 0 &&
                                      _duration!.second == 0)
                              ? null
                              : _duration);
                    },
                    child: Text(
                      'create'.tr,
                      style: Styles.textStyleProjectChipText,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
