import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/constants.dart';

class EmptyTodo extends StatelessWidget {
  const EmptyTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Colors.yellow,
            size: 30.0,
          ),
          const SizedBox(width: 15.0),
          Text(
            'noTasksToDo'.tr,
            style: AppTextStyles.noTasksToDo,
          ),
        ],
      ),
      tween: Tween<double>(begin: 160.0, end: 70.0),
      duration: const Duration(milliseconds: 300),
      builder: (
        BuildContext context,
        double _size,
        Widget? child,
      ) =>
          SizedBox(
        height: _size,
        child: child,
      ),
    );
  }
}
