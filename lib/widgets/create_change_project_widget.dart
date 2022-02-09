import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/models/project_model.dart';
import 'package:todoz_app/models/todo_model.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/color_picker.dart';
import 'package:todoz_app/widgets/cover_picker.dart';
import 'package:todoz_app/widgets/project_preview.dart';

class CreateProjectWidget extends StatefulWidget {
  const CreateProjectWidget(
      {Key? key,
      this.projectModel,
      required this.isCreate,
      required this.todoModels})
      : super(key: key);
  final ProjectModel? projectModel;
  final bool isCreate;
  final List<TodoModel?>? todoModels;

  @override
  State<CreateProjectWidget> createState() => _CreateProjectWidgetState();
}

class _CreateProjectWidgetState extends State<CreateProjectWidget> {
  late TextEditingController _textEditingController;
  late ProjectController _projectController;
  late AuthController _authcontroller;
  late Color _pickedColor;
  late String _pickedCover;
  late String _projectName;

  void createOrChange() {
    if (widget.isCreate == true) {
      List<String> retVal = [];
      for (var element in _projectController.projects) {
        retVal.add(element!.projectName);
      }
      if (retVal.contains(_textEditingController.text) == false) {
        ProjectController().addProject(_textEditingController,
            _authcontroller.user!.uid, _pickedColor, _pickedCover);
      } else {
        Get.snackbar('Error', 'Project already exist',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Database().updateProject(
          _pickedColor,
          _authcontroller.user!.uid,
          _pickedCover,
          _projectName,
          widget.projectModel!.projectId,
          widget.todoModels);
    }
  }

  static const List<Color> _colors = [
    Color(0xffF7AD78),
    Color(0xff78A3F7),
    Color(0xffC790FF),
    Color(0xffFF7C7C),
    Color(0xff79E397),
    Color(0xffB3C7C6),
    Color(0xffFD84B7),
  ];

  static const List<String> _urlImages = [
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fappreciation_project.svg?alt=media&token=adb7e417-a4a8-4922-a096-d1ae1d182248',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fastronaut_project.svg?alt=media&token=19ef5815-28d8-4efb-8637-51239a131819',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fbuilding_project.svg?alt=media&token=18c65323-f725-4ee5-83f6-a6cd0f8646e9',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fcalendar_project.svg?alt=media&token=4da2ce6e-b0a2-4576-8f1a-8bdda405fb65',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fdepilation_project.svg?alt=media&token=ce92fa19-e4c5-4e88-acd1-7269a7a7f8d7',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fdestination_project.svg?alt=media&token=368bbbff-510d-48b5-98dd-bbf2a5337dec',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fexperts_project.svg?alt=media&token=343cd408-ca79-4629-b58e-768fde4f3359',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fhome-run_project.svg?alt=media&token=cbd300ea-f4f3-4190-ac75-a12f00171d63',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Finternet_project.svg?alt=media&token=a76129d4-3027-42ee-bd5b-2208cb462d28',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fjavascript-frameworks_project.svg?alt=media&token=ffb0180a-10c5-4814-8c9e-1c291a3db5b6',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fmaintenance_project.svg?alt=media&token=aa7ddd25-4010-4f64-bc49-e5200ee1af0f',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fpalette_project.svg?alt=media&token=1aa81b13-c6b9-46a7-8db8-1ef93ae9d216',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fphotos_project.svg?alt=media&token=ae32fe78-7cd1-4537-b111-bd089de72c91',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fplain-credit-card_project.svg?alt=media&token=58e2bd26-12dd-4221-8a5d-5ff5f228d5c9',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fresume_project.svg?alt=media&token=653b8b7d-562d-435a-92fa-30c12609fc89',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fsnowman_project.svg?alt=media&token=10aff551-a38b-49ea-9732-801b0fc2d074',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fsuperhero_project.svg?alt=media&token=f22706f5-a70b-4744-8c7b-00cd78df6074',
    'https://firebasestorage.googleapis.com/v0/b/todoz-3aee8.appspot.com/o/project_covers%2Fyacht_project.svg?alt=media&token=cc3306fa-4d5a-43e9-ac59-ffcab980396c',
  ];

  @override
  void initState() {
    _authcontroller = Get.find<AuthController>();
    _textEditingController = TextEditingController();
    _projectController = Get.find<ProjectController>();
    _projectName = widget.isCreate == true
        ? 'newProject'.tr
        : widget.projectModel!.projectName;
    _pickedColor = widget.isCreate == true
        ? _colors[0]
        : Color(int.parse(widget.projectModel!.color));
    _pickedCover = widget.isCreate == true
        ? _urlImages[0]
        : widget.projectModel!.projectCover;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double width = Get.width;
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
                  widget.isCreate == true ? 'newProject'.tr : 'change'.tr,
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
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(5.0)),
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
          Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: ProjectPreviewWidget(
                  projectName: _projectName,
                  color: _pickedColor.value.toString(),
                  height: 180,
                  width: width,
                  cover: _pickedCover,
                  isCreate: widget.isCreate)),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              onChanged: (value) => setState(() {
                _projectName = _textEditingController.text;
              }),
              controller: _textEditingController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(17.0),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: .0),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: .0),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  filled: true,
                  fillColor: const Color(0xFFEEF1F7),
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: .0),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  hintText: 'titleHint'.tr,
                  hintStyle: const TextStyle(fontSize: 16.0)),
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'chooseColor'.tr,
              style: Styles.textStyleBlackSmallText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: ColorPicker(
              availableColors: _colors,
              initialColor: _pickedColor,
              onSelectColor: (Color value) {
                setState(() {
                  _pickedColor = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'chooseCover'.tr,
              style: Styles.textStyleBlackSmallText,
            ),
          ),
          CoverPicker(
            availableCovers: _urlImages,
            initialCover: _pickedCover,
            onSelectCover: (String url) {
              setState(() {
                _pickedCover = url;
              });
            },
          ),
          SizedBox(height: height / 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.isCreate == false
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all(
                                Colors.black.withOpacity(0.2)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(10.0)),
                            minimumSize: MaterialStateProperty.all(
                                const Size(20.0, 20.0)),
                            elevation: MaterialStateProperty.all(5.0),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          deleteProject();
                        },
                        child: const Icon(
                          EvaIcons.trash2,
                          size: 20.0,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(.0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff6E4AFF))),
                    onPressed: () {
                      setState(() {
                        createOrChange();
                      });
                    },
                    child: Text(
                      widget.isCreate == true ? 'create'.tr : 'change'.tr,
                      style: Styles.textStyleProjectChipText,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteProject() async {
    Get.back();
    Get.back();
    await Future.delayed(const Duration(seconds: 1));
    Database().deleteProject(_authcontroller.user!.uid,
        widget.projectModel!.projectId, widget.todoModels);
  }
}
