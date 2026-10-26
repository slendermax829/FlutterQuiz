import 'package:flutter/material.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/widgets/QuestionDisplayer.dart';
import 'package:flutterquiz/pages/ResultsScreen.dart';

class QuizSession extends StatefulWidget {
  final String _quizName;
  final List<Question> _questions;

  const new({
    super.key,
    required String quizName,
    required List<Question> questions,
  }) : this._quizName = quizName,
       this._questions = questions;

  @override
  State<QuizSession> createState() => _QuizSessionState();
}

class _QuizSessionState extends State<QuizSession> {
  final GlobalKey<QuestionDisplayerState> _displayerKey = GlobalKey(); // to link data for current quiz data

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => changeBackGround(bg: CustomBackgrounds.QUIZ_SESSION),
    );
    super.initState();
  }
  /// Shows Actions from bottomSheet if user presses the '...' symbol
  void _showSessionActions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Restart Quiz'),
                onTap: () {
                  Navigator.pop(context);
                  _restartQuiz();
                },
              ),
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('Submit Quiz'),
                onTap: () {
                  Navigator.pop(context);
                  _submitQuiz();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Quiz Info'),
                onTap: () {
                  Navigator.pop(context);
                  _displayInfo();
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Exit'),
                onTap: () {
                  Navigator.pop(context);
                  _quitQuiz();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Restarts the quiz
  /// 
  /// Resets all questions back to unanswered
  void _restartQuiz() async{
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (context){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.blue.shade100,
          title: const Text('Restart Quiz'),
          content: const Text('Do you want to restart your current quiz session?\n\nNote: Questions will not be saved'),
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
                backgroundColor: Colors.blue
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        );
      }
    );

    if (!mounted || confirm != true) {
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuizSession(
          quizName: widget._quizName,
          questions: widget._questions,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Displays the current quiz info via alertDialogBox
  void _displayInfo() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade100,
          title: const Center(child: Text('Quiz Info')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Quiz Name: ${widget._quizName}'),
              Text('Questions: ${widget._questions.length}'),
            ],
          ),
        );
      },
    );
  }

  /// Quits the current quiz and returns back to [HomePage]
  void _quitQuiz() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('Quit current quiz?'),
          content: Text('Would you like to quit your current session?'),
          backgroundColor: Colors.blue.shade100,
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirm != true) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setToDefault());
    Navigator.pop(context);
  }
  /// Submits the quiz which then transitions to the [ResultsScreen]
  /// 
  /// If any question is unanswered, it prompts a warning message to the user before submission
  void _submitQuiz() async {

    final displayer = _displayerKey.currentState; // get the question displayer results

    if (displayer == null) return; // if displayer key does not exist

    if (!displayer.allAnswered) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.blue.shade100,
          title: const Text('Submit Quiz'),
          content: const Text(
            'You have unanswered questions. Submit anyway?\n\nWARNING: Unanswered questions will be counted as incorrect.',
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
                backgroundColor: Colors.red
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      );
      if (!mounted || confirm != true) return; // removes the warning message
    }

    final graded = displayer.gradeQuiz(); // gets the grade for the current quiz session
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) => ResultsScreen(
          quizName: widget._quizName,
          finalScore: graded.finalScore,
          correctQuestions: graded.correct,
          incorrectQuestions: graded.incorrect,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget._quizName),
        backgroundColor: const Color.fromARGB(128, 0, 0, 0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showSessionActions,
            icon: const Icon(Icons.more_vert),
            tooltip: 'Quiz actions',
          ),
        ],
      ),
      body: QuestionDisplayer(key: _displayerKey, questions: widget._questions)
    );
  }
}
