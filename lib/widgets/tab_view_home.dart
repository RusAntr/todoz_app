import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:todoz_app/pages/home.dart';
import 'package:todoz_app/pages/projects_page.dart';
import 'package:todoz_app/utils/circleWheelScroll/circle_wheel_scroll_view.dart'
    as circle_wheel;
import 'package:todoz_app/widgets/floating_buttons.dart';
import 'package:todoz_app/widgets/wheel_navigation_bar.dart';

import 'createTodo.dart';

class TabViewHome extends StatefulWidget {
  const TabViewHome({Key? key}) : super(key: key);

  @override
  State<TabViewHome> createState() => _TabViewHomeState();
}

class _TabViewHomeState extends State<TabViewHome> {
  List<WheelNavigationItem> list = [
    WheelNavigationItem(
        Icon(Icons.circle, color: Colors.black.withOpacity(0.2), size: 7),
        'homePage'.tr,
        Icon(Icons.circle, color: Colors.black.withOpacity(0.7), size: 12)),
    WheelNavigationItem(
        Icon(Icons.circle, color: Colors.black.withOpacity(0.2), size: 7),
        'projectsPage'.tr,
        Icon(Icons.circle, color: Colors.black.withOpacity(0.7), size: 12)),
    WheelNavigationItem(
        Icon(Icons.circle, color: Colors.black.withOpacity(0.2), size: 7),
        'profilePage'.tr,
        Icon(Icons.circle, color: Colors.black.withOpacity(0.7), size: 12)),
  ];

  List<Widget> pages = [
    const Home(),
    const ProjectsPage(),
    CreateTodo(
      visibility: true,
    )
  ];
  int currentIndex = 0;
  late PageController _pageController;
  late circle_wheel.FixedExtentScrollController _scrollController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _scrollController =
        circle_wheel.FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
                children: pages,
                pageSnapping: true,
                controller: _pageController,
                onPageChanged: (int index) => setState(() {
                      currentIndex = index;
                      _scrollController.animateToItem(currentIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    })),
            Container(
              color: Colors.transparent,
              height: 100,
              width: width,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    bottom: currentIndex == 2 ? 10 : 35,
                    child: SizedBox(
                      width: width,
                      height: 70,
                      child: WheelNavigationBar(
                        axis: Axis.horizontal,
                        radius: 60,
                        scrollController: _scrollController,
                        itemExtent: 70,
                        onSelectedItemChanged: (int index) => setState(() {
                          currentIndex = index;
                          _pageController.animateToPage(currentIndex,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear);
                        }),
                        currentIndex: currentIndex,
                        items: list,
                      ),
                    ),
                  ),
                  FloatingButtons(index: currentIndex)
                ],
              ),
            ),
          ],
        ));
  }
}
