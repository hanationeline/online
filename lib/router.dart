import 'package:go_router/go_router.dart';
import 'package:oneline/screens/calendar_screen.dart';
import 'package:oneline/screens/add_event_page.dart';
import 'package:oneline/screens/todo_page.dart';
import 'package:oneline/screens/schedule_page.dart';
import 'package:oneline/main_navi.dart';

final router = GoRouter(
  initialLocation: "/mainnavi",
  routes: [
    GoRoute(
      path: MainNavigationScreen.routeURL,
      name: MainNavigationScreen.routeName,
      builder: (context, state) => const MainNavigationScreen(),
      routes: [
        GoRoute(
          path: 'calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: 'add-event',
          builder: (context, state) => const AddEventPage(),
        ),
        GoRoute(
          path: 'todo',
          builder: (context, state) => const TodoPage(),
        ),
        GoRoute(
          path: 'schedule',
          builder: (context, state) => const SchedulePage(),
        ),
      ],
    ),
  ],
);
