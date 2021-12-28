import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  /// This function sends the selected color to outside
  final Function? onSelectColor;

  /// List of pickable colors
  final List<Color>? availableColors;

  /// The default picked color
  final Color? initialColor;

  const ColorPicker({
    Key? key,
    this.onSelectColor,
    this.availableColors,
    this.initialColor,
  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _pickedColor;

  @override
  void initState() {
    _pickedColor = widget.initialColor!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 50,
      width: width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.availableColors!.length,
        itemBuilder: (_, index) {
          final itemColor = widget.availableColors![index];
          return Padding(
            padding: (index == 0)
                ? const EdgeInsets.only(left: 15, right: 5)
                : (index == 6)
                    ? const EdgeInsets.only(right: 15, left: 5)
                    : const EdgeInsets.only(left: 5, right: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onSelectColor!(itemColor);
                  _pickedColor = itemColor;
                });
              },
              child: Container(
                height: 35,
                width: 35,
                decoration:
                    BoxDecoration(color: itemColor, shape: BoxShape.circle),
                child: itemColor == _pickedColor
                    ? const Center(
                        child: Icon(
                        EvaIcons.checkmark,
                        color: Colors.white,
                      ))
                    : Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}
