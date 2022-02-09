import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todoz_app/controllers/project_controller.dart';
import 'package:todoz_app/controllers/todo_controller.dart';
import 'package:todoz_app/pages/home_page.dart';
import 'package:todoz_app/pages/productivity_page.dart';
import 'package:todoz_app/pages/profile_page.dart';
import 'package:todoz_app/pages/projects_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const HomePage(),
    const ProjectsPage(),
    const ProductivityPage(),
    ProfilePage()
  ];
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  bool get _isCreate {
    if (_currentIndex == 0 || _currentIndex == 1) {
      return true;
    } else {
      return false;
    }
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
                    highlightColor: Colors.transparent),
                child: BottomNavigationBar(
                  elevation: 0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  enableFeedback: true,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: const Color(0xffEBE4FF),
                  currentIndex: _currentIndex,
                  unselectedItemColor: const Color(0xffC1AFF6),
                  selectedItemColor: const Color(0xff5F33E1),
                  onTap: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: [
                    /// Home
                    const BottomNavigationBarItem(
                      label: '',
                      icon: Icon(Icons.home_rounded),
                    ),

                    /// Projects
                    BottomNavigationBarItem(
                      label: '',
                      icon: AnimatedPadding(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.bounceOut,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: _isCreate ? 40.0 : 0),
                        child: const Icon(EvaIcons.folder),
                      ),
                    ),

                    /// Productivity
                    BottomNavigationBarItem(
                      label: '',
                      icon: AnimatedPadding(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.bounceOut,
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: _isCreate ? 40.0 : 0),
                          child: const Icon(EvaIcons.activity)),
                    ),

                    /// Profile
                    const BottomNavigationBarItem(
                      label: '',
                      icon: Icon(Icons.person_rounded),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_currentIndex == 0) {
                    TodoController().openCreateTodo(context, true, null);
                  } else if (_currentIndex == 1) {
                    ProjectController()
                        .openCreateProject(context, null, true, null);
                  } else {}
                },
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                  child: Icon(
                    Icons.add_rounded,
                    color: const Color(0xffC1AFF6),
                    size: _isCreate ? 30 : 0,
                  ),
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          )),
    );
  }
}
