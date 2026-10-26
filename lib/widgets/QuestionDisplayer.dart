import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/backend/QuizService.dart' as service;
import 'package:http/http.dart';

/// Displays quiz questions and tracks the user's answers.
class QuestionDisplayer extends StatefulWidget {
  /// Questions for current quiz
  final List<Question> _questions;

  /// Creates a question displayer for [questions].
  const QuestionDisplayer({super.key, required List<Question> questions})
    : _questions = questions;

  /// Creates the state that tracks answers and navigation through the quiz.
  @override
  State<QuestionDisplayer> createState() => QuestionDisplayerState();
}

/// Manages question navigation, answer input, and quiz grading.
class QuestionDisplayerState extends State<QuestionDisplayer> {
  /// The current question displayed
  late Question _currQuestion;

  /// The current question index
  late int _currentQuestionIndex;

  /// A list of booleans that represent if a question is answered or not for each value
  late final List<bool> _answeredQuestions;

  /// A map for inputs for multiple choice questions
  final Map<int, int> _selectedChoices = {};

   /// A map for inputs for fill in the blank questions
  final Map<int, String> _typedAnswers = {};

  /// A text editing controller for saving fill in the blank responses
  final TextEditingController _textController = TextEditingController();

  /// The one-based number of the question currently being displayed.
  int get questionNum => _currentQuestionIndex + 1;

  /// If the current question displayed is the first question
  bool get _isFirstQuestion => _currentQuestionIndex == 0;

  ///If the current question displayed is the last question
  bool get _isLastQuestion => _currentQuestionIndex == widget._questions.length - 1;

  /// Whether the user has answered every question.
  bool get allAnswered => _answeredQuestions.every((a) => a);

  /// Grades the quiz and separates correct and incorrect answers.
  ///
  /// Unanswered questions are counted as incorrect. Each answer entry contains
  /// the submitted answer text and its corresponding question.
  ({int finalScore, List<(String, Question)> correct, List<(String, Question)> incorrect}) gradeQuiz() {
    var correct = <(String, Question)>[];
    var incorrect = <(String, Question)>[];

    for (var (i, q) in widget._questions.indexed) {
      var answer = q is MultipleChoice ? _selectedChoices[i] : _typedAnswers[i];
      (_answeredQuestions[i] && q.isCorrect(answer) ? correct : incorrect).add((
        q is MultipleChoice ? (_selectedChoices[i] == null ? '' : q.getOption(_selectedChoices[i]!)) : (_typedAnswers[i] ?? ''),q)
      );
    }

    var totalQuestions = correct.length + incorrect.length;
    var score = (correct.length / totalQuestions * 100).round();

    return (finalScore: score, correct: correct, incorrect: incorrect);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _answeredQuestions = List.filled(widget._questions.length, false);

    _currentQuestionIndex = 0;
    _currQuestion = widget._questions[_currentQuestionIndex];
  }

  /// Sets the current question from [questionIndex]
  void _setCurrentQuestion(int questionIndex) {
    _currentQuestionIndex = questionIndex;
    _currQuestion = widget._questions[questionIndex];
  }
  
  /// Changes the question by [step]
  /// 
  /// [step] can be 1 for next question and -1 for previous question
  /// calls [setState] at the end of the function
  void _changeQuestion(int step){
    final nextQuestionIndex = _currentQuestionIndex + step;

    if (nextQuestionIndex < 0 ||
        nextQuestionIndex >= widget._questions.length) {
      return;
    }

    setState(() {
      _setCurrentQuestion(nextQuestionIndex);
      _textController.text = _typedAnswers[nextQuestionIndex] ?? ''; // set the text for the controller to be the saved answer for fill in the blank questions
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            spacing: 20,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.fromARGB(84, 0, 0, 0),
                  border: BoxBorder.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LayoutBuilder( // a small bar above that represents the questions answered or not
                  builder: (context, constraints) {
                    final int count = _answeredQuestions.length;
                    if (count == 0) return const SizedBox(height: 24); // if no questions are available
                    
                    const double maxDotSize = 12.0;
                    const double outerPadding = 8.0;
      
                    final double slotSize = (constraints.maxWidth - 2 * outerPadding) / count;
                    final double gap = (slotSize * 0.25).clamp(1.0, 20.0);
                    final double dot = (slotSize - gap).clamp(3.0, maxDotSize);
      
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: outerPadding,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(count, (index) { // generates the dots
                          final isAnswered = _answeredQuestions[index];
      
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 125),
                            width: dot,
                            height: dot,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: index == _currentQuestionIndex ? Border.all(color: Colors.lightBlueAccent): null,
                              color: isAnswered ? Colors.green: const Color.fromARGB(145, 79, 79, 79),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
              DecoratedBox( // Navigation Arrows
                decoration: BoxDecoration(
                  color: Color.fromARGB(84, 0, 0, 0),
                  border: BoxBorder.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  spacing: 50,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.blue,
                        backgroundColor: Color.fromARGB(160, 119, 119, 119),
                      ),
                      onPressed: _isFirstQuestion ? null : () => _changeQuestion(-1), // null if first question
                      child: Icon(Icons.arrow_back),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.blue,
                        backgroundColor: Color.fromARGB(160, 119, 119, 119),
                      ),
                      onPressed: _isLastQuestion ? null : () => _changeQuestion(1), // null if last question
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
              DecoratedBox( // Question Prompt
                decoration: BoxDecoration(
                  color: Color.fromARGB(84, 0, 0, 0),
                  border: BoxBorder.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Question $questionNum of ${widget._questions.length}',
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
                    if(_currQuestion.figure != '')
                      FutureBuilder<Response>(
                        future: service.fetchImage(_currQuestion.figure), 
                        builder:(context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }else if(snapshot.hasError){
                            return Icon(Icons.broken_image);
                          }else if(snapshot.hasData && snapshot.data != null){
                            return Image.memory(
                              snapshot.data!.bodyBytes,
                              fit: BoxFit.cover,
                            );
                          }
                          return Placeholder();
                        },
                    ),
                    SizedBox(height: 16),
                    if (_currQuestion case final MultipleChoice mc) // when the current question is a multiple choice
                      RadioGroup<int>(
                        groupValue: _selectedChoices[_currentQuestionIndex], // multiple choice questions are in the form of a RadioGroup
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() { // save multiple choice user input
                            _selectedChoices[_currentQuestionIndex] = value;
                            _answeredQuestions[_currentQuestionIndex] = true;
                          });
                        },
                        child: Column(
                          children: [
                            for (final (i, option) in mc.choices.indexed)
                              RadioListTile<int>(
                                value: i,
                                title: Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                activeColor: Colors.lightBlue,
                              ),
                          ],
                        ),
                      )
                    else if (_currQuestion is FillInBlank) // When current question is a fill in the blank
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 10,
                            ),
                            labelText: 'Your answer',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (text) { // save current fill in the blank user text in map
                            setState(() {
                              _typedAnswers[_currentQuestionIndex] = text;
                              _answeredQuestions[_currentQuestionIndex] = text.trim().isNotEmpty;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
