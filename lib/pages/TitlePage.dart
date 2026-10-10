import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/widgets/LoginForm.dart';

class TitlePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //Container(color: Colors.tealAccent),
          Background(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    spacing: 30,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlutterLogo(
                        size: 65,
                        textColor: Colors.white,
                        curve: Curves.fastOutSlowIn,
                      ),
                      Text(
                        'FlutterQuiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontFamily: 'Trebuchet',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      
                      Text(
                        'A quiz application to test your knowledge both on Dart and Flutter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Trebuchet',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      LoginForm(),
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }
}