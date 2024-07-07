import 'package:go_router/go_router.dart';
import 'package:oneline/calendar_screen.dart';
import 'package:oneline/main_navi.dart';

final router = GoRouter(
  initialLocation: "/mainnavi",
  routes: [
    GoRoute(
      path: MainNavigationScreen.routeURL,
      name: MainNavigationScreen.routeName,
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    // GoRoute(
    //   path: '/serverList',
    //   builder: (context, state) => ServerListScreen(),
    // ),
    // GoRoute(
    //   path: '/workSchedule',
    //   builder: (context, state) => WorkScheduleScreen(),
    // ),
  ],
);
