import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';

class FloatingButtons extends StatelessWidget {
  FloatingButtons({Key? key, this.index}) : super(key: key);

  int? index;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        top: index == 2 ? 100 : 35,
        duration: const Duration(milliseconds: 500),
        child: GestureDetector(
            onTap: () {
              index == 0
                  ? TodoController().openCreateTodo(context, true, null)
                  : ProjectController()
                      .openCreateProject(context, null, true, null);
            },
            child: AnimatedContainer(
                duration: index == 0
                    ? const Duration(milliseconds: 1000)
                    : const Duration(milliseconds: 1000),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (index == 0)
                        ? const Color(0xffEBE4FF)
                        : Colors.white.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.17),
                          offset: const Offset(0, 20),
                          blurRadius: 15)
                    ]),
                child: (index == 0)
                    ? const Icon(EvaIcons.plus,
                        color: Color(0xff6E4AFF), size: 30)
                    : const Icon(EvaIcons.plus,
                        color: Color(0xffE87171), size: 30))));
  }
}
