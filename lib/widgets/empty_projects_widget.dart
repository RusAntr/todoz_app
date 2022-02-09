import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todoz_app/utils/styles.dart';

class EmptyProjectsWidget extends StatelessWidget {
  const EmptyProjectsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(top: 250.0),
        child: Column(
          children: [
            const Icon(Icons.folder, color: Color(0xffC1AFF6), size: 120),
            Text(
              'noProjects'.tr,
              textAlign: TextAlign.center,
              style: Styles.noTasksToDo.copyWith(fontSize: 15.0),
            ),
            const SizedBox(height: 15.0),
            Icon(
              Icons.south_rounded,
              color: Colors.black.withOpacity(0.3),
              size: 40.0,
            )
          ],
        ));
  }
}
