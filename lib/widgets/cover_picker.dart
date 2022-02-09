import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CoverPicker extends StatefulWidget {
  const CoverPicker({
    Key? key,
    this.onSelectCover,
    this.availableCovers,
    this.initialCover,
  }) : super(key: key);

  /// This function sends the selected cover to outside
  final Function? onSelectCover;

  /// List of pickable covers
  final List<String>? availableCovers;

  /// The default picked cover
  final String? initialCover;

  @override
  State<CoverPicker> createState() => _CoverPickerState();
}

class _CoverPickerState extends State<CoverPicker> {
  late String _pickedCover;

  @override
  void initState() {
    _pickedCover = widget.initialCover!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return SizedBox(
      height: 100.0,
      width: width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.availableCovers!.length,
        itemBuilder: (_, index) {
          final itemCover = widget.availableCovers![index];
          return Padding(
            padding: (index == 0)
                ? const EdgeInsets.only(left: 15.0, right: 10.0)
                : (index == 6)
                    ? const EdgeInsets.only(right: 15.0, left: 10.0)
                    : const EdgeInsets.only(left: 10.0, right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onSelectCover!(itemCover);
                  _pickedCover = itemCover;
                });
              },
              child: Container(
                alignment: Alignment.center,
                child: SvgPicture.network(
                  widget.availableCovers![index],
                  height: itemCover == _pickedCover ? 100.0 : 80.0,
                  width: itemCover == _pickedCover ? 100.0 : 80.0,
                  placeholderBuilder: (context) => SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        color: Colors.black.withOpacity(0.3),
                      )),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
