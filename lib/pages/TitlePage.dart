import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/widgets/LoginForm.dart';

class TitlePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          //Container(color: Colors.tealAccent),
          SafeArea(
            maintainBottomViewPadding: true,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Column(
                      spacing: 25,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlutterLogo(
                          size: 52,
                          textColor: Colors.white,
                          curve: Curves.fastOutSlowIn,
                        ),
                        Text(
                          'FlutterQuiz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontFamily: 'Trebuchet',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        
                        Text(
                          'A quiz application to test your knowledge both on Dart and Flutter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Trebuchet',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    
                        const LoginForm(),
                      ],
                    ),
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