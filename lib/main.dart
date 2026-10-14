import 'package:flutter/material.dart';
import 'package:flutterquiz/pages/HomePage.dart';
import 'package:flutterquiz/pages/TitlePage.dart';
import 'package:flutterquiz/widgets/Background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Background(),
            if (child != null) child,
          ],
        );
      },
      home: TitlePage(),
    );
  }
}
