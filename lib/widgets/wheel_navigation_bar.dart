import 'package:flutter/material.dart';
import 'package:todoz_app/utils/circleWheelScroll/circle_wheel_scroll_view.dart';
import 'package:todoz_app/utils/styles.dart';

class WheelNavigationBar extends StatelessWidget {
  final List<WheelNavigationItem>? items;
  int? currentIndex;
  double? itemExtent;
  final ValueChanged<int>? onSelectedItemChanged;
  final ScrollController? scrollController;
  ScrollPhysics? physics;
  Axis? axis;

  WheelNavigationBar({
    Key? key,
    this.physics,
    this.axis,
    @required this.currentIndex,
    @required this.scrollController,
    @required this.itemExtent,
    @required this.items,
    @required this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleListScrollView(
      radius: 60,
      axis: Axis.horizontal,
      itemExtent: itemExtent!,
      physics: BouncingScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      children: [
        for (final item in items!)
          Center(
            child: Column(
              children: [
                items!.indexOf(item) == currentIndex
                    ? Text(
                        item.title,
                        style: Styles().textStyleBlackSmallText,
                      )
                    : Text(''),
                items!.indexOf(item) == currentIndex
                    ? item.activeIcon!
                    : item.icon,
              ],
            ),
          )
      ],
      controller: scrollController,
    );
  }
}

class WheelNavigationItem {
  /// An icon to display.
  final Widget icon;

  /// Text to display, ie `Home`
  final String title;

  final Widget? activeIcon;

  WheelNavigationItem(this.icon, this.title, this.activeIcon);
}
