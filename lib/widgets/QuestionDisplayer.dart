import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Question.dart';

class QuestionDisplayer extends StatefulWidget {
  final List<Question> _questions;

  const QuestionDisplayer({super.key, required List<Question> questions})
    : _questions = questions;

  @override
  State<QuestionDisplayer> createState() => _QuestionDisplayerState();
}

class _QuestionDisplayerState extends State<QuestionDisplayer> {

  final ValueNotifier<List<(String, String, bool)>> shareDataNoitifer = ValueNotifier([]);

  late Question _currQuestion;
  late int _currentQuestionIndex;

  late final List<bool> answeredQuestions;
  late final List<({String userAnswer, Question question})> questionRecords;

  int get questionNum => _currentQuestionIndex + 1;

  bool get _isFirstQuestion => _currentQuestionIndex == 0;
  bool get _isLastQuestion => _currentQuestionIndex == widget._questions.length - 1;

  final Map<int, int> _selectedChoices = {};
  final Map<int, String> _typedAnswers = {};

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    answeredQuestions = List.filled(widget._questions.length, false);
    questionRecords = [];

    _currentQuestionIndex = 0;
    _currQuestion = widget._questions[_currentQuestionIndex];
  }

  void _setCurrentQuestion(int questionIndex) {
    _currentQuestionIndex = questionIndex;
    _currQuestion = widget._questions[questionIndex];
  }

  void _changeQuestion(int step) {
    final nextQuestionIndex = _currentQuestionIndex + step;

    if (nextQuestionIndex < 0 ||
        nextQuestionIndex >= widget._questions.length) {
      return;
    }

    setState(() {
      _setCurrentQuestion(nextQuestionIndex);
      _textController.text = _typedAnswers[nextQuestionIndex] ?? '';
    });
  }

  void _goBack() => _changeQuestion(-1);

  void _goForward() => _changeQuestion(1);


  @override
  Widget build(BuildContext context) {
    return Padding(
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
              child: Builder(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ...List.generate(answeredQuestions.length, (index) {
                          final isAnswered = answeredQuestions[index];
          
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 125),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: index == _currentQuestionIndex
                                    ? BoxBorder.all(color: Colors.yellowAccent)
                                    : null,
                                color: isAnswered ? Colors.green : Color.fromARGB(145, 79, 79, 79),
                              ),
                              child: isAnswered
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }),
                        Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: _isFirstQuestion ? null : _goBack,
                              child: Icon(Icons.arrow_back),
                            ),
                            ElevatedButton(
                              onPressed: _isLastQuestion ? null : _goForward,
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
            ),
            DecoratedBox(
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _currQuestion.stem,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 30),
                if (_currQuestion case final MultipleChoice mc)
                  RadioGroup<int>(
                    groupValue: _selectedChoices[_currentQuestionIndex],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedChoices[_currentQuestionIndex] = value;
                        answeredQuestions[_currentQuestionIndex] = true;
                      });
                    },
                    child: Column(
                      children: [
                        for (final (i, option) in mc.choices.indexed)
                          RadioListTile<int>(
                            value: i,
                            title: Text(
                              option,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  )
                else if (_currQuestion is FillInBlank)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Your answer',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _typedAnswers[_currentQuestionIndex] = text;
                          answeredQuestions[_currentQuestionIndex] =
                              text.trim().isNotEmpty;
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
    );
  }
}
