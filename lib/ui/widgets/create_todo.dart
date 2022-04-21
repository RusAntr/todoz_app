import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/constants/constants.dart';
import 'package:todoz_app/controllers/localization_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/ui/ui_export.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../data/models/models.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({
    Key? key,
    required this.showAllProjects,
    required this.projectModel,
  }) : super(key: key);

  final bool showAllProjects;
  final ProjectModel projectModel;

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  ProjectModel? _pickedProject;
  ProjectModel? _initialProject;
  DateTime? _dateUntil;
  DateTime? _duration;
  final TextEditingController _textEditingController = TextEditingController();
  late TodoController _todoController;
  late LocalizationController _localizationController;
  late ProjectController _projectController;

  @override
  void initState() {
    _projectController = Get.put(ProjectController());
    if (_projectController.projects.isNotEmpty) {
      _pickedProject = _projectController.projects[0];
    }
    _todoController = Get.find<TodoController>();
    _localizationController = Get.find<LocalizationController>();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          _textField(),
          const SizedBox(height: 10.0),
          _addToProjectTitle(),
          const SizedBox(height: 10.0),
          _projectPicker(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _dateButton(),
              _durationButton(),
              _createButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(AppColors.mainPurple),
        ),
        onPressed: () {
          _todoController.addTodo(
            projectName: widget.showAllProjects == true
                ? _pickedProject!.projectName
                : widget.projectModel.projectName,
            content: _textEditingController.text,
            projectId: widget.showAllProjects == true
                ? _pickedProject!.projectId
                : widget.projectModel.projectId,
            dateUntil: _dateUntil.isBlank == true ? null : _dateUntil,
            duration: _duration == null ||
                    (_duration!.hour == 0 &&
                        _duration!.minute == 0 &&
                        _duration!.second == 0)
                ? null
                : _duration,
          );
          _textEditingController.clear();
        },
        child: Text(
          'create'.tr,
          style: AppTextStyles.textStyleProjectChipText,
        ),
      ),
    );
  }

  Widget _durationButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(16.0),
          shadowColor: MaterialStateProperty.all(
            Colors.black.withOpacity(0.2),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () async {
          _duration = await DatePicker.showTimePicker(context,
              theme: DatePickerTheme(
                itemStyle: AppTextStyles.dateTimeItem,
              ),
              locale: _localizationController.currentLocaleType,
              currentTime: DateTime(DateTime.now().year, 0, 0, 0, 0, 0, 0, 0),
              onConfirm: (date) => _duration = date);
        },
        child: Row(
          children: [
            const Icon(
              EvaIcons.clockOutline,
              size: 15.0,
              color: Colors.black,
            ),
            const SizedBox(width: 5.0),
            Text(
              'duration'.tr,
              style: AppTextStyles.dateTimeItem,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(16.0),
          shadowColor: MaterialStateProperty.all(
            Colors.black.withOpacity(0.2),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () async {
          _dateUntil = await DatePicker.showDateTimePicker(context,
              locale: _localizationController.currentLocaleType,
              currentTime: DateTime.now(),
              theme: DatePickerTheme(itemStyle: AppTextStyles.dateTimeItem),
              minTime: DateTime(DateTime.now().year - 1),
              maxTime: DateTime(DateTime.now().year + 1),
              onConfirm: (date) => _dateUntil = date);
        },
        child: Row(
          children: [
            const Icon(
              EvaIcons.calendarOutline,
              size: 15.0,
              color: Colors.black,
            ),
            const SizedBox(width: 5.0),
            Text(
              'date'.tr,
              style: AppTextStyles.dateTimeItem,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addToProjectTitle() {
    return Visibility(
      visible: widget.showAllProjects,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          'addToProject'.tr,
          style: AppTextStyles.textStyleBlackSmallText,
        ),
      ),
    );
  }

  Widget _projectPicker() {
    return Visibility(
      visible: widget.showAllProjects,
      child: GetX<ProjectController>(
        builder: (_) {
          if (_projectController.projects.isNotEmpty) {
            _initialProject = _projectController.projects[0];
            return SizedBox(
              height: 100.0,
              width: Get.width,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: ProjectPicker(
                  onSelectProject: (ProjectModel model) =>
                      setState(() => _pickedProject = model),
                  initialProject: _initialProject,
                  availableProjects: _projectController.projects,
                ),
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 15.0),
                GestureDetector(
                  onTap: () => _projectController.openCreateProject(
                    context: context,
                    projectModel: null,
                    isCreate: true,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    height: 90.0,
                    width: 95.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.grey[500],
                    ),
                    child: Center(
                      child: Icon(
                        EvaIcons.plusSquare,
                        size: 30.0,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Padding _textField() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
      child: TextField(
        controller: _textEditingController,
        decoration: AppInputDecoarations.createTodoTextField.copyWith(
          hintText: 'titleHint'.tr,
        ),
      ),
    );
  }

  Row _title() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  'newTask'.tr,
                  style: AppTextStyles.textStyleAddTaskText,
                ),
              ),
              const Positioned(
                right: 15,
                child: CustomCloseButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
