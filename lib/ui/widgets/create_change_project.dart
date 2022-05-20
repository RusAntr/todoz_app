import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/core/constants/url_images.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/ui/ui_export.dart';
import '../../core/constants/constants.dart';
import '../../data/models/models.dart';

class CreateChangeProject extends StatefulWidget {
  const CreateChangeProject({
    Key? key,
    this.projectModel,
    required this.isCreate,
    required this.todoModels,
  }) : super(key: key);
  final ProjectModel? projectModel;
  final bool isCreate;
  final List<TodoModel?>? todoModels;

  @override
  State<CreateChangeProject> createState() => _CreateChangeProjectState();
}

class _CreateChangeProjectState extends State<CreateChangeProject> {
  late TextEditingController _textEditingController;
  late ProjectController _projectController;
  late Color _pickedColor;
  late String _pickedCover;
  late String _projectName;

  static const List<Color> _colors = [
    AppColors.projectOrange,
    AppColors.projectBlue,
    AppColors.projectPurple,
    AppColors.projectRed,
    AppColors.projectGreen,
    AppColors.projectGray,
    AppColors.projectPink,
  ];

  @override
  void initState() {
    _projectController = Get.find<ProjectController>();
    _textEditingController = TextEditingController();
    _projectName =
        widget.isCreate ? 'newProject'.tr : widget.projectModel!.projectName;
    _pickedColor = widget.isCreate
        ? _colors[0]
        : AppColors().getColor(widget.projectModel!.color);
    _pickedCover = widget.isCreate
        ? UrlImages().images.values.toList()[0]
        : UrlImages().selectedCoverValue(widget.projectModel!.projectCover);
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
          _projectPreview(),
          _nameField(),
          _colorTitle(),
          _colorPicker(),
          _coverTitle(),
          _coverPicker(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              !widget.isCreate ? _deleteButton() : const SizedBox(),
              _createChangeButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createChangeButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(AppColors.mainPurple),
        ),
        onPressed: () => setState(() => createOrChange()),
        child: Text(
          widget.isCreate ? 'create'.tr : 'change'.tr,
          style: AppTextStyles.textStyleProjectChipText,
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(
            Colors.black.withOpacity(0.2),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(10.0),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(20.0, 20.0),
          ),
          elevation: MaterialStateProperty.all(5.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () {
          _projectController.deleteProject(
            projectId: widget.projectModel!.projectId,
            todoModels: widget.todoModels,
          );
        },
        child: const Icon(
          EvaIcons.trash2,
          size: 20.0,
          color: Colors.red,
        ),
      ),
    );
  }

  CoverPicker _coverPicker() {
    return CoverPicker(
      availableCovers: UrlImages().images.values.toList(),
      initialCover: _pickedCover,
      onSelectCover: (String url) => setState(
        () => _pickedCover = url,
      ),
    );
  }

  Widget _coverTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(
        'chooseCover'.tr,
        style: AppTextStyles.textStyleBlackSmallText,
      ),
    );
  }

  Widget _colorPicker() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: ColorPicker(
        availableColors: _colors,
        initialColor: _pickedColor,
        onSelectColor: (Color value) => setState(() => _pickedColor = value),
      ),
    );
  }

  Widget _colorTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15),
      child: Text(
        'chooseColor'.tr,
        style: AppTextStyles.textStyleBlackSmallText,
      ),
    );
  }

  Widget _nameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextField(
        onChanged: (value) =>
            setState(() => _projectName = _textEditingController.text),
        controller: _textEditingController,
        decoration: AppInputDecoarations.createTodoTextField
            .copyWith(hintText: 'titleHint'.tr),
      ),
    );
  }

  Widget _projectPreview() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 20.0,
        top: 10,
      ),
      child: ProjectPreview(
        projectName: _projectName,
        color: _pickedColor.value.toString(),
        height: 180,
        width: Get.width,
        cover: _pickedCover,
        isCreate: widget.isCreate,
      ),
    );
  }

  Widget _title() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  widget.isCreate ? 'newProject'.tr : 'change'.tr,
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

  void createOrChange() {
    if (widget.isCreate) {
      _projectController.addProject(
        controller: _textEditingController,
        color: _pickedColor,
        projectCover: UrlImages().selectedCoverKey(_pickedCover),
      );
    } else {
      _projectController.updateProject(
        color: _pickedColor,
        projectCover: UrlImages().selectedCoverKey(_pickedCover),
        projectName: _projectName,
        projectId: widget.projectModel!.projectId,
        todoModels: widget.todoModels,
      );
    }
  }
}
