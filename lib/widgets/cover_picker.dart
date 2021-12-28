import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoverPicker extends StatefulWidget {
  /// This function sends the selected cover to outside
  final Function? onSelectCover;

  /// List of pickable covers
  final List<String>? availableCovers;

  /// The default picked cover
  final String? initialCover;

  const CoverPicker({
    Key? key,
    this.onSelectCover,
    this.availableCovers,
    this.initialCover,
  }) : super(key: key);

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
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 100,
      width: width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.availableCovers!.length,
        itemBuilder: (_, index) {
          final itemCover = widget.availableCovers![index];
          return Padding(
            padding: (index == 0)
                ? const EdgeInsets.only(left: 15, right: 10)
                : (index == 6)
                    ? const EdgeInsets.only(right: 15, left: 10)
                    : const EdgeInsets.only(left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onSelectCover!(itemCover);
                  _pickedCover = itemCover;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  itemCover == _pickedCover
                      ? SvgPicture.network(
                          widget.availableCovers![index],
                          height: 100,
                          width: 100,
                        )
                      : SvgPicture.network(
                          widget.availableCovers![index],
                          height: 80,
                          width: 80,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
