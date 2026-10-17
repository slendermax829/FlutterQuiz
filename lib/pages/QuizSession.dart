import 'package:flutter/material.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/widgets/QuestionDisplayer.dart';
import 'package:flutterquiz/pages/ResultsScreen.dart';

class QuizSession extends StatefulWidget {
  final bool _isPractice;
  final String _quizName;
  final List<Question> _questions;

  const new({
    super.key,
    required String quizName,
    required List<Question> questions,
    bool isPractice = false,
  }) : this._quizName = quizName,
       this._questions = questions,
       this._isPractice = isPractice;

  @override
  State<QuizSession> createState() => _QuizSessionState();
}

class _QuizSessionState extends State<QuizSession> {
  final GlobalKey<QuestionDisplayerState> _displayerKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => changeBackGround(bg: CustomBackgrounds.QUIZ_SESSION),
    );
    super.initState();
  }

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

  void _displayInfo() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Quiz Info')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quiz Name: ${widget._quizName}'),
              Text('Questions: ${widget._questions.length}'),
              Text(widget._isPractice ? 'Mode: Practice' : 'Mode: Standard'),
            ],
          ),
        );
      },
    );
  }

  void _quitQuiz() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quit current quiz?'),
          content: Text('Would you like to quit your current session?'),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.redAccent;
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.red.shade700;
                  }
                  return Colors.redAccent;
                }),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
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

  void _submitQuiz() async {

    final displayer = _displayerKey.currentState;

    if (displayer == null) return;

    if (!displayer.allAnswered) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Submit Quiz'),
          content: const Text(
            'You have unanswered questions. Submit anyway?\n\nUnanswered questions will be counted as wrong.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      );
      if (!mounted || confirm != true) return;
    }

    final graded = displayer.grade();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          quizName: widget._quizName,
          finalScore: graded.finalScore,
          correctQuestions: graded.correct,
          incorrectQuestions: graded.incorrect,
        ),
      ),
    );
  }

  void _restartQuiz() async{
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text('Restart Quiz'),
          content: const Text('Do you want to restart your current quiz session?\n\nNote: Questions will not be saved'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context,false), 
              child: const Text('Cancel')
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true), 
              child: const Text('Confirm')
            )
          ],
        );
      }
    );

    if (!mounted || confirm != true) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizSession(
          quizName: widget._quizName,
          questions: widget._questions,
          isPractice: widget._isPractice,
        ),
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
