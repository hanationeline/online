import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneline/constrant/gaps.dart';
import 'package:oneline/constrant/sizes.dart';

class MainNavigationScreen extends StatefulWidget {
  static const routeURL = "/mainnavi";
  static const routeName = "mainnavi";
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _animation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  late final Animation<Offset> _panalAnimation = Tween(
    begin: const Offset(0, -5),
    end: Offset.zero,
  ).animate(_animationController);

  void _onTitleTap() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Rotate Sample'),
              Gaps.h3,
              RotationTransition(
                turns: _animation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size16,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: NavigationRail(
                  selectedLabelTextStyle:
                      const TextStyle(fontSize: Sizes.size24),
                  minWidth: 80,
                  elevation: 4,
                  useIndicator: false,
                  indicatorColor: Colors.teal.shade100,
                  backgroundColor: Colors.grey.shade100,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTap,
                  destinations: const [
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.arrowTrendUp,
                      ),
                      label: Text('test'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.computer,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.heartPulse,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.bell,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.peopleGroup,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.chartSimple,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.timeline,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.bug,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.calendarDay,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.clockRotateLeft,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.eyeSlash,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.userGear,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.lock,
                      ),
                      label: Text('data'),
                    ),
                    NavigationRailDestination(
                      icon: FaIcon(
                        FontAwesomeIcons.fileShield,
                      ),
                      label: Text('data'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Offstage(
                    offstage: _selectedIndex != 0,
                    child: Container(
                      child: const Text('data1'),
                    ),
                  ),
                  Offstage(
                    offstage: _selectedIndex != 1,
                    child: Container(
                      child: const Text('data2'),
                    ),
                  ),
                  Offstage(
                    offstage: _selectedIndex != 2,
                    child: Container(
                      child: const Text('data3'),
                    ),
                  ),
                  Offstage(
                    offstage: _selectedIndex != 3,
                    child: Container(
                      child: const Text('data4'),
                    ),
                  ),
                  SlideTransition(
                    position: _panalAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Sizes.size20),
                          bottomRight: Radius.circular(Sizes.size20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var tab in _tabs)
                            ListTile(
                              title: Row(
                                children: [
                                  FaIcon(
                                    tab["icon"],
                                    color: Colors.black,
                                    size: Sizes.size16,
                                  ),
                                  Gaps.h20,
                                  Text(
                                    tab["title"],
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
