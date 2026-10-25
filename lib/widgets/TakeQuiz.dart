import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Quiz.dart';
import 'package:flutterquiz/pages/QuizSession.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/backend/QuizPool.dart' as pool;

/// Displays the available preset quizzes and lets users start one.
class TakeQuiz extends StatefulWidget {
  const new({super.key});

  @override
  State<TakeQuiz> createState() => _TakeQuizState();
}

class _TakeQuizState extends State<TakeQuiz> {

  /// Presents a confirmation box to inform the user the quiz they are about to take
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
              Text('Number of Questions: ${selectedQuiz.numQuestions}'),
            ],
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Take Quiz'),
            ),
          ],
        );
      },
    );

    if ((confirm ?? false) && mounted) {

      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:(context, animation, secondaryAnimation) => QuizSession(questions: selectedQuiz.questions, quizName: selectedQuiz.name),
          transitionsBuilder: (context, animation, secondaryAnimation, child){
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        )
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
                  itemCount: pool.numOfQuizzes,
                  itemBuilder: (context, index) {
                    final quiz = pool.quizzes[index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlue,
                        child: Text('${index + 1}'),
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
                        pool.quizzes.firstWhere(
                          (q) => q.quizNo == index + 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
