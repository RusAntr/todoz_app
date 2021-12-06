// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:todoz_app/models/projectModel.dart';
import 'package:todoz_app/utils/styles.dart';

class ProjectChoiceChip extends StatelessWidget {
  final ProjectModel? projectModel;
  final bool? isSelected;
  const ProjectChoiceChip({Key? key, this.isSelected, this.projectModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.all(10),
          height: isSelected == true ? 80 : 80,
          width: isSelected == true ? 85 : 85,
          decoration: isSelected == false
              ? BoxDecoration(
                  boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xffE2C9FC))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xffE2C9FC)),
          child: Center(
            child: Text(
              projectModel!.projectName!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Styles().textStyleProjectChipText,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
