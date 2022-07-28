import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gold_trading_playground/views/master_page.dart';

void main() {
  runApp(
    const ProviderScope(
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
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
          titleMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black87),
          titleSmall: TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
      ),
      home: const MasterPage(),
    );
  }
}

