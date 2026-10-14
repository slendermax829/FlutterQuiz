import 'package:flutter/material.dart';
import 'package:flutterquiz/pages/HomePage.dart';

class TakeQuiz extends StatefulWidget {

  const new({super.key});

  @override
  State<TakeQuiz> createState() => _TakeQuizState();
}

class _TakeQuizState extends State<TakeQuiz> {
  bool _isPractice = false;

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          margin: EdgeInsetsGeometry.all(20),
          padding: EdgeInsets.all(10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.fromARGB(84, 0, 0, 0),
              border: BoxBorder.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(15), 
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Available Quizzes',style: TextStyle(color: Colors.white,fontSize: 24),),
                Expanded(
                  child: ListView.builder(
                    itemCount: HomePage.pool.numOfQuizzes,
                    itemBuilder: (context, index) {
                      final quiz = HomePage.pool.quizzes[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index+1}'),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightBlue,
                        ),
                        title: Text(quiz.name, style: TextStyle(color: Colors.white),),
                        subtitle: Text('${quiz.numQuestions} questions',style: TextStyle(color: const Color.fromARGB(255, 152, 151, 151)),),
                        hoverColor: Color.fromARGB(124, 0, 136, 255),
                        onTap: () => print('Selected ${quiz.name} (practice: $_isPractice)'),
                      );
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text(
                    'Practice mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _isPractice,
                  onChanged: (value) => setState(() => _isPractice = value),
                  inactiveTrackColor: Colors.transparent,
                  inactiveThumbColor: const Color.fromARGB(255, 29, 12, 211),
                  activeThumbColor: Colors.lightBlue,
                  hoverColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      );
  }
}