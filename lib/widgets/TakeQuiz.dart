import 'package:flutter/material.dart';

class TakeQuiz extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          margin: EdgeInsetsGeometry.all(15),
          padding: EdgeInsets.all(15),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: BoxBorder.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(15), 
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Available Quizzes',style: TextStyle(fontSize: 24, decoration: TextDecoration.underline),),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.tealAccent,)
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}