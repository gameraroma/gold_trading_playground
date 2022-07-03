import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/my_home_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Trading',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Color(0x00999999)),
          titleMedium: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Color(0x00999999)),
          titleSmall: TextStyle(fontSize: 24.0, color: Color(0x00444444)),
        ),
      ),
      home: const MyHomePage(title: 'Gold Trading Playground'),
    );
  }
}

