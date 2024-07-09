import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneline/models/tab_model.dart';

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
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              onTap(index);
            },
            destinations: tabs.map((tab) {
              return NavigationRailDestination(
                icon: FaIcon(tab.icon),
                label: Text(tab.title),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
