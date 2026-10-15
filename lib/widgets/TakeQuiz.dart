import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Quiz.dart';
import 'package:flutterquiz/pages/HomePage.dart';
import 'package:flutterquiz/pages/QuizSession.dart';
import 'package:flutterquiz/widgets/Background.dart';

class TakeQuiz extends StatefulWidget {
  const new({super.key});

  @override
  State<TakeQuiz> createState() => _TakeQuizState();
}

class _TakeQuizState extends State<TakeQuiz> {
  bool _isPractice = false;

  void _confirmQuiz(Quiz selectedQuiz) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.blue,
          backgroundColor: Colors.blue.shade100,
          titlePadding: EdgeInsets.all(8),
          title: Center(child: Text('Confirm Quiz')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quiz Name: ${selectedQuiz.name}'),
              Text('Number of Questions: ${selectedQuiz.numQuestions}\n'),
              Text(_isPractice ? 'PRACTICE ENABLED' : 'PRACTICE DISABLED'),
            ],
          ),
          actions: [
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.blue.shade300;
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.blue.shade800;
                  }
                  return Colors.blue;
                }),
              ),
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.blue.shade300;
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.blue.shade800;
                  }
                  return Colors.blue;
                }),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Take Quiz'),
            ),
          ],
        );
      },
    );

    if ((confirm ?? false) && mounted) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => QuizSession(
            questions: [],
            quizName: selectedQuiz.name,
          ),
        ),
      );
    
      if (mounted) setToDefault();
    }
  }

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
              Text(
                'Available Quizzes',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                'Take a pre-set quiz below.',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: HomePage.pool.numOfQuizzes,
                  itemBuilder: (context, index) {
                    final quiz = HomePage.pool.quizzes[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlue,
                      ),
                      title: Text(
                        quiz.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${quiz.numQuestions} questions',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 152, 151, 151),
                        ),
                      ),
                      hoverColor: Color.fromARGB(124, 0, 136, 255),
                      onTap: () => _confirmQuiz(
                        HomePage.pool.quizzes.firstWhere(
                          (q) => q.quizNo == index + 1,
                        ),
                      ),
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
