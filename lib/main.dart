import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tag_client/screens/loginpage.dart';
import 'package:tag_client/screens/scanpage.dart';

void main() => runApp(const MyApp());

// final storage = FlutterSecureStorage();

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
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.3,
          fontSizeDelta: 2.0,
        ),

      ),
      home: const LoginPage(),
    );
  }
}
