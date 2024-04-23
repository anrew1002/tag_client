import 'package:flutter/material.dart';
import 'package:tag_client/screens/scanpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Tag List';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF286BC4)),
        useMaterial3: true,

      ),
      home: const ScanPage(),
    );
  }
}
