import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/utils/styles.dart';

class EmptyTodoWidget extends StatefulWidget {
  const EmptyTodoWidget({Key? key}) : super(key: key);

  @override
  State<EmptyTodoWidget> createState() => _EmptyTodoWidgetState();
}

class _EmptyTodoWidgetState extends State<EmptyTodoWidget> {
  final double _endValue = 70.0;
  late Tween<double> _values;

  @override
  void initState() {
    _values = Tween<double>(begin: 160.0, end: _endValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double size, Widget? child) {
        return AnimatedContainer(
          height: size,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
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
                style: Styles.noTasksToDo,
              ),
            ],
          ),
        );
      },
      duration: const Duration(milliseconds: 300),
      tween: _values,
    );
  }
}
