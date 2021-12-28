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
    int retrivedColor = int.parse(projectModel!.color);
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.all(15),
          height: isSelected == true ? 90 : 80,
          width: isSelected == true ? 95 : 85,
          decoration: isSelected == false
              ? BoxDecoration(
                  boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 8),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                  borderRadius: BorderRadius.circular(25),
                  color: Color(retrivedColor))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(retrivedColor)),
          child: Center(
            child: Text(
              projectModel!.projectName,
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
