import 'package:flutter/material.dart';
import 'package:oneline/models/eosl_provider.dart';
import 'package:oneline/router.dart';
import 'package:provider/provider.dart';
import 'package:oneline/provider/event_provider.dart';
import 'package:oneline/models/contact_provider.dart';
import 'package:oneline/models/server_provider.dart'; // 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => ServerProvider()),
        ChangeNotifierProvider(create: (context) => EoslProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
