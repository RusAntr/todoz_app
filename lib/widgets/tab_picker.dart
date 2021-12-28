import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoz_app/controllers/todoController.dart';

class TabPicker extends StatefulWidget {
  /// This function sends the selected widget to outside
  final Function? onSelectWidget;

  /// List of pickable Widgets
  final List<int>? availableWidgets;

  /// The default picked widget
  final int? initialWidget;

  /// Project's name
  final String? projectName;

  /// Project's color
  final String? projectColor;

  const TabPicker({
    Key? key,
    this.onSelectWidget,
    this.availableWidgets,
    this.initialWidget,
    this.projectName,
    this.projectColor,
  }) : super(key: key);

  @override
  State<TabPicker> createState() => _TabPickerState();
}

class _TabPickerState extends State<TabPicker> {
  late int _pickedWidget;

  @override
  void initState() {
    _pickedWidget = widget.initialWidget!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int retrivedColor = int.parse(widget.projectColor!);
    final width = MediaQuery.of(context).size.width;
    final itemWidget = widget.availableWidgets!;
    return SizedBox(
        height: 40,
        width: width - 60,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ///ALL
          TextButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Color(retrivedColor)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(left: 15, right: 15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200))),
                  backgroundColor: _pickedWidget == 1
                      ? MaterialStateProperty.all<Color>(Color(retrivedColor))
                      : MaterialStateProperty.all<Color>(
                          Color(retrivedColor).withOpacity(0.2))),
              onPressed: () {
                setState(() {
                  widget.onSelectWidget!(itemWidget[0]);
                  _pickedWidget = itemWidget[0];
                });
              },
              child: Row(children: [
                Text('all'.tr,
                    style: GoogleFonts.poppins(
                        color: _pickedWidget == 1
                            ? Colors.white
                            : Color(retrivedColor),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                GetX<TodoController>(
                    init: Get.put<TodoController>(TodoController()),
                    builder: (TodoController todoController) {
                      if (todoController.isBlank != null &&
                          todoController.todos
                              .where((element) =>
                                  element!.projectName == widget.projectName)
                              .isNotEmpty) {
                      } else {}
                      return Text(
                        todoController.todos
                            .where((element) =>
                                element!.projectName == widget.projectName)
                            .length
                            .toString(),
                        style: GoogleFonts.poppins(
                            color: _pickedWidget == 1
                                ? Colors.white
                                : Color(retrivedColor),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      );
                    }),
              ])),

          //Done
          TextButton(
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all<Color>(Color(retrivedColor)),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.fromLTRB(15, 0, 15, 0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200))),
                backgroundColor: _pickedWidget == 3
                    ? MaterialStateProperty.all<Color>(Color(retrivedColor))
                    : MaterialStateProperty.all<Color>(
                        Color(retrivedColor).withOpacity(0.2))),
            onPressed: () {
              setState(() {
                widget.onSelectWidget!(itemWidget[2]);
                _pickedWidget = itemWidget[2];
              });
            },
            child: Row(children: [
              Text(
                'taskDone'.tr,
                style: GoogleFonts.poppins(
                    color: _pickedWidget == 3
                        ? Colors.white
                        : Color(retrivedColor),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              GetX<TodoController>(
                  init: Get.put<TodoController>(TodoController()),
                  builder: (TodoController todoController) {
                    if (todoController.isBlank != null &&
                        todoController.todos
                            .where((element) =>
                                element!.projectName == widget.projectName)
                            .isNotEmpty) {
                    } else {}
                    return Text(
                      todoController.todos
                          .where((element) =>
                              element!.projectName == widget.projectName &&
                              element.isDone == true)
                          .length
                          .toString(),
                      style: GoogleFonts.poppins(
                          color: _pickedWidget == 3
                              ? Colors.white
                              : Color(retrivedColor),
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    );
                  }),
            ]),
          ),
          //UNDONE
          TextButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Color(retrivedColor)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.fromLTRB(15, 0, 15, 0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200))),
                  backgroundColor: _pickedWidget == 2
                      ? MaterialStateProperty.all<Color>(Color(retrivedColor))
                      : MaterialStateProperty.all<Color>(
                          Color(retrivedColor).withOpacity(0.2))),
              onPressed: () {
                setState(() {
                  widget.onSelectWidget!(itemWidget[1]);
                  _pickedWidget = itemWidget[1];
                });
              },
              child: Row(
                children: [
                  Text('taskUndone'.tr,
                      style: GoogleFonts.poppins(
                          color: _pickedWidget == 2
                              ? Colors.white
                              : Color(retrivedColor),
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  GetX<TodoController>(
                      init: Get.put<TodoController>(TodoController()),
                      builder: (TodoController todoController) {
                        if (todoController.isBlank != null &&
                            todoController.todos
                                .where((element) =>
                                    element!.projectName == widget.projectName)
                                .isNotEmpty) {
                        } else {}
                        return Text(
                          todoController.todos
                              .where((element) =>
                                  element!.projectName == widget.projectName &&
                                  element.isDone == false)
                              .length
                              .toString(),
                          style: GoogleFonts.poppins(
                              color: _pickedWidget == 2
                                  ? Colors.white
                                  : Color(retrivedColor),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                ],
              ))
        ]));
  }
}
