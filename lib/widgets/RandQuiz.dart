import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterquiz/pages/HomePage.dart';
import 'package:flutterquiz/backend/QuizPool.dart' as pool;
import 'package:flutterquiz/pages/QuizSession.dart';
import 'package:flutterquiz/widgets/Background.dart';

class RandQuiz extends StatefulWidget {
  const new({super.key});

  @override
  State<RandQuiz> createState() => _RandQuizState();
}

class _RandQuizState extends State<RandQuiz> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const String _mcOnly = 'Multiple Choice only';
  static const String _fibOnly = 'Fill in the Blank only';
  static const String _any = 'Any';
  static const String _defaultName = 'RandomQuiz';

  String? _quizName;
  String? _selectedQuizType;
  double _questionCount = 1;

  int get _maxQuestions {
    switch (_selectedQuizType) {
      case _mcOnly:
        return pool.numMCQuestions;
      case _fibOnly:
        return pool.numFIBQuestions;
      case _any:
        return pool.numOfQuestions;
      default:
        return 0;
    }
  }

  void _onTypeChanged(String? value){
    setState(() {
      _selectedQuizType = value;
      _questionCount = 1;
    });
  }

  void _confirmQuiz() async {
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (context){
        return AlertDialog(
          surfaceTintColor: Colors.blue,
          backgroundColor: Colors.blue.shade100,
          titlePadding: EdgeInsets.all(8),
          title: Center(child: Text('Confirm Quiz')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quiz Name: ${_textController.text}'),
              Text('Number of Questions: ${_questionCount.toInt()}'),
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
      }
    );

    if ((confirm ?? false) && mounted){
      var name = _textController.text;

      final type = switch (_selectedQuizType) {
        _mcOnly => 'multiple choice',
        _fibOnly => 'fill in the blank',
        _ => null,
      };

      var randQuestions = pool.getRandomQuestions(_questionCount.round(), type: type);

      if (randQuestions.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No questions available for this selection')),
        );
        return;
      }

      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => QuizSession(
            questions: randQuestions,
            quizName: name,
          ),
        ),
      );
      if (mounted) setToDefault();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        margin: EdgeInsetsGeometry.all(20),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(84, 0, 0, 0),
                    border: BoxBorder.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    margin: EdgeInsetsGeometry.all(5),
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Random Quiz',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _textController,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            label: Text('Quiz Name'),
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A name must be filled out';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  color: Color.fromARGB(84, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Quiz Type',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      RadioGroup<String>(
                        groupValue: _selectedQuizType,
                        onChanged: _onTypeChanged,
                        child: const Column(
                          children: [
                            RadioListTile<String>(
                              value: _mcOnly,
                              title: Text(
                                _mcOnly,
                                style: TextStyle(color: Colors.white),
                              ),
                              activeColor: Colors.lightBlue,
                            ),
                            RadioListTile<String>(
                              value: _fibOnly,
                              title: Text(
                                _fibOnly,
                                style: TextStyle(color: Colors.white),
                              ),
                              activeColor: Colors.lightBlue,
                            ),
                            RadioListTile<String>(
                              value: _any,
                              title: Text(
                                _any,
                                style: TextStyle(color: Colors.white),
                              ),
                              activeColor: Colors.lightBlue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedQuizType != null && _maxQuestions > 0)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(84, 0, 0, 0),
                      border: BoxBorder.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Questions: ${_questionCount.round()} of $_maxQuestions',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Slider(
                          value: _questionCount,
                          min: 1,
                          max: _maxQuestions.toDouble(),
                          divisions: _maxQuestions > 1
                              ? _maxQuestions - 1
                              : null,
                          label: _questionCount.round().toString(),
                          onChanged: _maxQuestions > 1
                              ? (value) =>
                                    setState(() => _questionCount = value)
                              : null,
                          thumbColor: Colors.lightBlue,
                          activeColor: Colors.lightBlue,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _confirmQuiz();
                            }
                          },
                          child: Text('Take Quiz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
