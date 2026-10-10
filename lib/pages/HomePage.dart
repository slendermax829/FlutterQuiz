import 'package:flutter/material.dart';
import 'package:flutterquiz/widgets/Background.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        Background(),
        SafeArea(
          child: Center(
            child: Column(
              children: [
                Text('A work in Progress lol')
              ],
            ),
          )
        )
      ],
    );
  }
}