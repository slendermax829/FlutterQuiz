import 'package:flutter/material.dart';
import 'package:flutterquiz/pages/HomePage.dart';

class RandQuiz extends StatefulWidget {
  const new({super.key});

  @override
  State<RandQuiz> createState() => _RandQuizState();
}

class _RandQuizState extends State<RandQuiz> {
  bool _isPractice = false;

  static const _mcOnly = 'Multiple Choice only';
  static const _fibOnly = 'Fill in the Blank only';
  static const _any = 'Any';

  String? _selectedQuizType;
  double _questionCount = 1;

  int get _maxQuestions {
    switch (_selectedQuizType) {
      case _mcOnly:
        return HomePage.pool.numMCQuestions;
      case _fibOnly:
        return HomePage.pool.numFIBQuestions;
      case _any:
        return HomePage.pool.numOfQuestions;
      default:
        return 0;
    }
  }

  void _onTypeChanged(String? value) {
    setState(() {
      _selectedQuizType = value;
      _questionCount = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white);
    final max = _maxQuestions;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromARGB(84, 0, 0, 0),
            border: BoxBorder.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 5,
              children: [
                const Text(
                  'Random Quiz',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                
                const Text(
                  'Create a random quiz to partake',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                  ),
                ),
                RadioGroup<String>(
                  groupValue: _selectedQuizType,
                  onChanged: _onTypeChanged,
                  child: const Column(
                    children: [
                      RadioListTile<String>(
                        value: _mcOnly,
                        title: Text(_mcOnly, style: textStyle),
                        selectedTileColor: Colors.lightBlue,
                        
                      ),
                      RadioListTile<String>(
                        value: _fibOnly,
                        title: Text(_fibOnly, style: textStyle),
                        selectedTileColor: Colors.lightBlue
                      ),
                      RadioListTile<String>(
                        value: _any,
                        title: Text(_any, style: textStyle),
                        selectedTileColor: Colors.lightBlue
                      ),
                    ],
                  ),
                ),
                if (_selectedQuizType != null && max > 0) ...[
                  Text(
                    'Questions: ${_questionCount.round()} of $max',
                    style: textStyle,
                  ),
                  Slider(
                    value: _questionCount,
                    min: 1,
                    max: max.toDouble(),
                    divisions: max > 1 ? max - 1 : null,
                    label: _questionCount.round().toString(),
                    onChanged: max > 1
                        ? (value) => setState(() => _questionCount = value)
                        : null,
                    thumbColor: Colors.lightBlue,
                    activeColor: Colors.lightBlue,
                  ),
                ],
                if (_selectedQuizType != null && max > 0)...[
                  SwitchListTile(
                    title: const Text(
                      'Practice Mode',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _isPractice, 
                    onChanged:(value) => setState(()=> _isPractice = value),
                    inactiveTrackColor: Colors.transparent,
                    inactiveThumbColor: const Color.fromARGB(255, 29, 12, 211),
                    activeThumbColor: Colors.lightBlue,
                    hoverColor: Colors.transparent,
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
