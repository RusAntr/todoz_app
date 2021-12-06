import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todoz_app/models/todoModel.dart';

class FloatingButtons extends StatelessWidget {
  FloatingButtons({Key? key, this.index}) : super(key: key);

  int? index;

  final Widget createToDo = Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffEBE4FF),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.17),
              offset: const Offset(0, 20),
              blurRadius: 15)
        ]),
    child: const Icon(EvaIcons.plus, color: Color(0xff6E4AFF), size: 30),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        top: index == 2 ? 100 : 35,
        duration: const Duration(milliseconds: 500),
        child: GestureDetector(
            onTap: () => TodoModel().openCreateTodo(context),
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
                        : const Color(0xffFFD4D4),
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
