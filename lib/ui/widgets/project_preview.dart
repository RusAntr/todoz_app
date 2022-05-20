import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/core/constants/url_images.dart';
import '../../core/constants/constants.dart';

class ProjectPreview extends StatefulWidget {
  const ProjectPreview({
    Key? key,
    required this.projectName,
    required this.color,
    required this.height,
    required this.width,
    required this.cover,
    required this.isCreate,
  }) : super(key: key);

  final String projectName;
  final String color;
  final double height;
  final double width;
  final String cover;
  final bool isCreate;

  @override
  _ProjectPreviewState createState() => _ProjectPreviewState();
}

class _ProjectPreviewState extends State<ProjectPreview> {
  late TodoController _todoController;
  late Artboard _animArtboard;

  /// Initializes asset needed for [Rive] and puts an animation on repeat
  void _initRiveCover() {
    rootBundle
        .load(
            'assets/images_and_animations/project_covers/${UrlImages().selectedCoverKey(widget.cover)}_project.riv')
        .then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        setState(() {
          _animArtboard = artboard;
          _animArtboard.addController(SimpleAnimation('loop'));
        });
      },
    );
  }

  @override
  void initState() {
    _initRiveCover();
    _todoController = Get.find<TodoController>();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProjectPreview oldWidget) {
    oldWidget.cover != widget.cover ? _initRiveCover() : () {};
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.isCreate
        ? 0
        : _todoController.doneTasksInProjectPercent(widget.projectName);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.fromLTRB(25.0, 10.0, 5.0, 10.0),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: AppColors().getColor(widget.color).withOpacity(1.0),
          ),
          child: GetX<TodoController>(
            builder: (_todoController) {
              return Stack(
                alignment: Alignment.centerRight,
                fit: StackFit.expand,
                children: [
                  Positioned(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleTasks(),
                        Text(
                          (percentage == 0)
                              ? '0%'
                              : (percentage == 1)
                                  ? '100%'
                                  : (percentage * 100).toStringAsFixed(2) + '%',
                          style: AppTextStyles.blackTitleNormal.copyWith(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        _projectName(),
                      ],
                    ),
                  ),
                  _projectCover(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _titleTasks() {
    return Text(_todoController.allTasksInProjectTitle(widget.projectName),
        style: AppTextStyles.textStyleWhiteText.copyWith(fontSize: 13.0));
  }

  Widget _projectCover() {
    return Positioned(
      right: 20.0,
      child: SizedBox(
        height: 110.0,
        width: 110.0,
        child: Rive(artboard: _animArtboard),
      ),
    );
  }

  Widget _projectName() {
    return SizedBox(
      width: 120.0,
      child: Text(
        widget.projectName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: AppTextStyles.projectNameProjectCard.copyWith(fontSize: 16.0),
        textAlign: TextAlign.left,
      ),
    );
  }
}
