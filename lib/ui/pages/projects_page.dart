import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/ui/pages/inside_project_page.dart';
import 'package:todoz_app/ui/widgets/search_bar.dart';
import '../../core/constants/constants.dart';
import '../ui_export.dart';
import '../widgets/profile_page_menu_items.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({Key? key}) : super(key: key);
  final ProjectController _projectController =
      Get.put<ProjectController>(ProjectController());

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  bool _isAscending = false;
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Scaffold(
      floatingActionButton: _fab(context),
      body: Material(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20.0),
                _kindaAppBar(),
                const SizedBox(height: 20.0),
                GetX<ProjectController>(
                    builder: (ProjectController projectController) =>
                        projectController.projects.isNotEmpty
                            ? _projectsList(width)
                            : const EmptyProjects())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _kindaAppBar() {
    return Row(
      children: [
        Text(
          'projectsPage'.tr,
          style: AppTextStyles.textStyleTitle,
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
                projectSortType: ProjectSortType.byDateCreated)),
            _buildItem(CustomMenuItem(
                text: 'sortName'.tr,
                icon: Icons.abc_rounded,
                projectSortType: ProjectSortType.byName)),
          ],
        ),
        SearchBar(
          textEditingController: _textEditingController,
          onChanged: (value) =>
              setState(() => widget._projectController.searchProjects(value)),
        ),
      ],
    );
  }

  _onSelectedItem(CustomMenuItem item) {
    setState(() {});
    for (var sortType in ProjectSortType.values) {
      item.projectSortType == sortType
          ? widget._projectController.sort(sortType, _isAscending)
          : () {};
    }
    _isAscending = _isAscending ? false : true;
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

  FloatingActionButton _fab(BuildContext context) {
    return FloatingActionButton(
      hoverElevation: 10.0,
      hoverColor: AppColors.darkPurple,
      splashColor: AppColors.darkPurple,
      elevation: 30.0,
      backgroundColor: AppColors.mainPurple,
      onPressed: () => widget._projectController.openCreateProject(
        context: context,
        projectModel: null,
        isCreate: true,
      ),
      child: const Icon(
        Icons.add_rounded,
      ),
    );
  }

  GetX _projectsList(double width) {
    return GetX<ProjectController>(
      builder: (_) {
        var projects = widget._projectController
            .searchProjects(_textEditingController.text);
        return ListView.builder(
          shrinkWrap: true,
          itemExtent: 210,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: projects.length,
          itemBuilder: (_, index) {
            var project = projects[index];
            return GestureDetector(
              onTap: () => Get.to(
                  () => InsideProjectPage(projectModel: project!),
                  transition: Transition.native,
                  duration: const Duration(milliseconds: 350)),
              child: ProjectCard(
                key: Key(project!.projectId),
                projectModel: project,
                height: 190.0,
                width: width,
              ),
            );
          },
        );
      },
    );
  }
}
