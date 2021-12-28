import 'package:flutter/material.dart';
import 'package:todoz_app/utils/circleWheelScroll/circle_wheel_scroll_view.dart';
import 'package:todoz_app/utils/styles.dart';

class WheelNavigationBar extends StatelessWidget {
  final List<WheelNavigationItem>? items;
  final int? currentIndex;
  final double? itemExtent;
  final ValueChanged<int>? onSelectedItemChanged;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final Axis? axis;
  final double? radius;

  const WheelNavigationBar(
      {Key? key,
      this.physics,
      this.axis,
      @required this.currentIndex,
      @required this.scrollController,
      @required this.itemExtent,
      @required this.items,
      @required this.onSelectedItemChanged,
      @required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleListScrollView(
      radius: radius!,
      axis: axis!,
      itemExtent: itemExtent!,
      physics: const BouncingScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      children: [
        for (final item in items!)
          Center(
            child: Column(
              children: [
                items!.indexOf(item) == currentIndex
                    ? Text(item.title, style: Styles().textStyleBlackSmallText)
                    : const Text(''),
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
