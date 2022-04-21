import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todoz_app/ui/pages/home_page.dart';
import 'package:todoz_app/ui/pages/productivity_page.dart';
import 'package:todoz_app/ui/pages/profile_page.dart';
import 'package:todoz_app/ui/pages/projects_page.dart';
import '../../core/constants/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const HomePage(),
    ProjectsPage(),
    ProductivityPage(),
    ProfilePage(),
  ];
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Stack(
          alignment: Alignment.center,
          children: [
            Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: true,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.lightPurple,
                currentIndex: _currentIndex,
                unselectedItemColor: AppColors.accentPurple,
                selectedItemColor: AppColors.mainPurple,
                onTap: (int index) => setState(() => _currentIndex = index),
                items: const [
                  /// Home
                  BottomNavigationBarItem(
                    label: '',
                    icon: Icon(Icons.home_rounded),
                  ),

                  /// Projects
                  BottomNavigationBarItem(
                    label: '',
                    icon: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: Icon(EvaIcons.folder),
                    ),
                  ),

                  /// Productivity
                  BottomNavigationBarItem(
                    label: '',
                    icon: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: Icon(EvaIcons.activity),
                    ),
                  ),

                  /// Profile
                  BottomNavigationBarItem(
                    label: '',
                    icon: Icon(Icons.person_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
    );
  }
}
