import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:oneline/models/server_provider.dart';
import 'package:oneline/screens/calendar_screen.dart';
import 'package:oneline/screens/add_event_page.dart';
import 'package:oneline/screens/eosl_list_page.dart';
import 'package:oneline/screens/server_detail.dart';
import 'package:oneline/screens/server_history.dart';
import 'package:oneline/screens/server_list.dart';
import 'package:oneline/screens/todo_page.dart';
import 'package:oneline/screens/schedule_page.dart';
import 'package:oneline/main_navi.dart';
import 'package:oneline/screens/contact_list_screen.dart';
import 'package:oneline/screens/contact_detail_page.dart';
import 'package:provider/provider.dart';

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
        GoRoute(
          path: 'contact',
          builder: (context, state) => const ContactListScreen(),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final contact = state.extra as Contact;
                return ContactDetailPage(contact: contact);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'server_list',
          builder: (context, state) => const ServerList(),
          routes: [
            GoRoute(
              path: 'server_detail/:serverNo',
              builder: (context, state) {
                final serverNo = state.params['serverNo']!;
                final serverProvider = context.read<ServerProvider>();
                final server = serverProvider.getServerByNo(serverNo);

                if (server == null) {
                  return const Scaffold(
                    body: Center(child: Text('Server not found')),
                  );
                }

                return ServerDetailPage(server: server, serverNo: serverNo);
              },
              routes: [
                GoRoute(
                  path: 'history',
                  builder: (context, state) {
                    final serverNo = state.params['serverNo']!;
                    final serverProvider = context.read<ServerProvider>();
                    final server = serverProvider.getServerByNo(serverNo);

                    if (server == null) {
                      return const Scaffold(
                        body: Center(
                          child: Text('Server not found'),
                        ),
                      );
                    }

                    final taskIndex = state.queryParams['taskIndex'] != null
                        ? int.parse(state.queryParams['taskIndex']!)
                        : 0;

                    return ServerHistoryPage(
                        server: server, taskIndex: taskIndex);
                  },
                ),
              ],
            ),
          ],
        ),
        // eosl 리스트 페이지 라우팅
        GoRoute(
          path: 'eosl_list',
          builder: (context, state) => const EoslListPage(),
        )
      ],
    ),
  ],
);
