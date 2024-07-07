import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const SideNavigationBar({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: NavigationRail(
            selectedLabelTextStyle: const TextStyle(fontSize: 24),
            minWidth: 80,
            elevation: 4,
            useIndicator: false,
            indicatorColor: Colors.teal.shade100,
            backgroundColor: Colors.grey.shade100,
            selectedIndex: selectedIndex == -1 ? null : selectedIndex,
            onDestinationSelected: (index) {
              onTap(index);
            },
            destinations: const [
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.calendarCheck),
                label: Text('Calendar'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.server),
                label: Text('Server List'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
                label: Text('Work Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
