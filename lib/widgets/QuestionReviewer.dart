import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Question.dart';

/// Displays the questions and answers from a completed quiz.
class QuestionReviewer extends StatefulWidget {
  final List<(String, Question)> _correctQuestions;
  final List<(String, Question)> _incorrectQuestions;

  /// Creates a reviewer for the supplied correct and incorrect answers.
  ///
  /// Each entry contains the user's answer and its corresponding question.
  const new({
    super.key,
    required List<(String, Question)> correctQuestions,
    required List<(String, Question)> incorrectQuestions
  }) : this._correctQuestions = correctQuestions,
       this._incorrectQuestions = incorrectQuestions;

  /// Creates the state that navigates between reviewed questions.
  @override
  State<QuestionReviewer> createState() => QuestionReviewerState();
}

/// Manages navigation through the completed quiz's questions.
class QuestionReviewerState extends State<QuestionReviewer> {
  /// A list of all the questions from the quiz
  late final List<(String, Question)> _allQuestions = [
    ...widget._correctQuestions,
    ...widget._incorrectQuestions,
  ];
  /// The one-based number of the question currently being displayed.
  int get _questionNum => _currIndex + 1;

  /// If the current question displayed is the first question
  bool get _isFirstQuestion => _currIndex == 0;

  ///If the current question displayed is the last question
  bool get _isLastQuestion => _currIndex == _allQuestions.length-1;

  /// The current question index
  late int _currIndex = 0;

  /// The current question displayed
  late Question _currQuestion;

  /// The current user's answer for the current questions displayed.
  late String _currUserAnswer;

  @override
  void initState() {
    _currIndex = 0;
    _currUserAnswer = _allQuestions[_currIndex].$1;
    _currQuestion = _allQuestions[_currIndex].$2;
    super.initState();
  }

  /// Sets the current question from [questionIndex]
  void _setCurrentQuestion(int questionIndex){
    _currIndex = questionIndex;
    _currQuestion = _allQuestions[_currIndex].$2;
    _currUserAnswer = _allQuestions[_currIndex].$1;
  }

  /// Changes the question by [step]
  /// 
  /// [step] can be 1 for next question and -1 for previous question
  /// calls [setState] at the end of the function
  void _changeQuestion(int step){
    final nextQuestionIndex = _currIndex + step;

    if (nextQuestionIndex < 0 ||
        nextQuestionIndex >= _allQuestions.length) {
      return;
    }

    setState(() {
      _setCurrentQuestion(nextQuestionIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(84, 0, 0, 0),
          border: BoxBorder.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Question $_questionNum of ${_allQuestions.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white
              ),
            ),
            SizedBox(height: 5),
            Text(
              _currQuestion.stem,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 16),
            if (_currQuestion case final MultipleChoice mc) ...[
              Text(
                'Correct Answer: ${mc.answer}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Your Answer: $_currUserAnswer',
                style: TextStyle(
                  color: mc.answer == _currUserAnswer
                      ? const Color.fromARGB(255, 62, 250, 68)
                      : Colors.red,
                ),
              ),
            ],
            if (_currQuestion case final FillInBlank fb) ...[
              if(_currQuestion case final FillInBlank fb)
              Text(
                'Correct Answer(s): ${fb.answers}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Your Answer: $_currUserAnswer',
                style: TextStyle(
                  color: fb.isCorrect(_currUserAnswer)
                      ? const Color.fromARGB(255, 62, 250, 68)
                      : Colors.red,
                ),
              ),
            ],
            SizedBox(height: 10),
            Builder(
              builder:(context) {
                return Row(
                  spacing: 50,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.tealAccent,
                        shadowColor: Colors.transparent,
                        iconColor: Colors.white,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: _isFirstQuestion ? null : () => _changeQuestion(-1),
                      child: Icon(Icons.arrow_back),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.tealAccent,
                        shadowColor: Colors.transparent,
                        iconColor: Colors.white,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: _isLastQuestion ? null : () => _changeQuestion(1),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                );
              },
            )
          ],
        )
      )
    );
  }
}