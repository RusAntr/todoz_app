import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../core/constants/constants.dart';

class EmptyProjects extends StatelessWidget {
  const EmptyProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          const Icon(
            Icons.folder,
            color: AppColors.accentPurple,
            size: 120,
          ),
          Text(
            'noProjects'.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.noTasksToDo.copyWith(fontSize: 15.0),
          ),
          const SizedBox(height: 15.0),
          Icon(
            Icons.south_rounded,
            color: Colors.black.withOpacity(0.3),
            size: 40.0,
          )
        ],
      ),
    );
  }
}
