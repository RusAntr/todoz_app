import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/models.dart';

class ProjectPicker extends StatefulWidget {
  const ProjectPicker({
    Key? key,
    this.onSelectProject,
    this.availableProjects,
    this.initialProject,
  }) : super(key: key);

  /// This function sends the selected cover to outside
  final Function? onSelectProject;

  /// List of pickable covers
  final List<ProjectModel?>? availableProjects;

  /// The default picked cover
  final ProjectModel? initialProject;

  @override
  State<ProjectPicker> createState() => _ProjectPickerState();
}

class _ProjectPickerState extends State<ProjectPicker> {
  late ProjectModel _pickedProject;
  late ProjectController _projectController;

  @override
  void initState() {
    _pickedProject = widget.initialProject!;
    _projectController = Get.find<ProjectController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 15.0),
        _createNewProject(),
        ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.availableProjects!.length,
          itemBuilder: (_, index) {
            final itemProject = widget.availableProjects![index];
            return Padding(
              padding: (index == 0)
                  ? const EdgeInsets.only(left: 15.0, right: 5.0)
                  : (index == widget.availableProjects!.length)
                      ? const EdgeInsets.only(right: 15.0, left: 5.0)
                      : const EdgeInsets.only(left: 10.0, right: 10.0),
              child: _pickProjects(itemProject),
            );
          },
        ),
      ],
    );
  }

  Widget _pickProjects(ProjectModel? itemProject) {
    return GestureDetector(
      onTap: () => setState(
        () {
          widget.onSelectProject!(itemProject);
          _pickedProject = itemProject!;
        },
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: AppColors().getColor(itemProject!.color),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  itemProject.projectName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppTextStyles.textStyleProjectChipText,
                ),
                itemProject == _pickedProject
                    ? const Icon(
                        EvaIcons.checkmark,
                        size: 20.0,
                        color: Colors.white,
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createNewProject() {
    return GestureDetector(
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
            size: 30,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
