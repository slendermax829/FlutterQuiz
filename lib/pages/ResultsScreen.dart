import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/Question.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class ResultsScreen extends StatelessWidget {
  final String _quizName;
  final int _finalScore;
  final List<Question> _correctQuestions;
  final List<Question> _incorrectQuestions;

  const ResultsScreen({
    super.key,
    required String quizName,
    required int finalScore,
    required List<Question> correctQuestions,
    required List<Question> incorrectQuestions,
  }) : _quizName = quizName,
       _finalScore = finalScore,
       _correctQuestions = correctQuestions,
       _incorrectQuestions = incorrectQuestions;

  int get _totalQuestions => [..._correctQuestions, ..._incorrectQuestions].length;

  double get _correctPercent => (_correctQuestions.length/_totalQuestions);
  double get _incorrectPercent => (_incorrectQuestions.length/_totalQuestions);

  void _saveQuiz(){
    debugPrint('saving quiz');
  }

  void _backToHomePage(BuildContext screenContext) {
    Navigator.pop(screenContext);
  }

  void _reviewQuiz(){
    debugPrint('reviewing quiz');
  }

  @override
  Widget build(BuildContext context) {
    final screenContext = context;
    WidgetsBinding.instance.addPostFrameCallback((_){
      _finalScore < 70 ? changeBackGround(bg: CustomBackgrounds.FAILED) : changeBackGround(bg: CustomBackgrounds.PASSED);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Results'),
        backgroundColor: const Color.fromARGB(139, 46, 45, 45),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder:(context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.search),
                        title: Text('Review Quiz'),
                        onTap: ()=> _reviewQuiz(),
                      ),
                      ListTile(
                        leading: Icon(Icons.save),
                        title: Text('Save Quiz'),
                        onTap: () => _saveQuiz(),
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Return to home'),
                        onTap: () {
                          Navigator.pop(context);
                          _backToHomePage(screenContext);
                        },
                      ),
                    ],
                  )
                );
              },
            ), 
            icon: const Icon(Icons.more_vert),
            tooltip: 'Result Actions',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(17),
        child: Container(
          margin: EdgeInsetsGeometry.all(20),
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.fromARGB(84, 0, 0, 0),
                  border: BoxBorder.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child:Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _finalScore >= 70 ? 
                    Text('PASSED',style: TextStyle(color: const Color.fromARGB(255, 28, 242, 0),fontSize: 25,fontWeight: FontWeight.bold),):
                    Text('FAILED',style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold)),
                    Text('$_quizName',style: TextStyle(color: Colors.white, fontSize: 18),),
                    Text('Total number of Questions: $_totalQuestions',style: TextStyle(color: Colors.white),),
                    Text('Correct Questions: ${_correctQuestions.length}',style: TextStyle(color: Colors.white)),
                    Text('Incorrect Questions: ${_incorrectQuestions.length}',style: TextStyle(color: Colors.white),)
                  ],
                )
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.fromARGB(84, 0, 0, 0),
                  border: BoxBorder.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularPercentIndicator(
                      radius: 45,
                      lineWidth: 10,
                      percent: _correctPercent,
                      header: Text('CORRECT ANSWERS',style: TextStyle(color: Colors.white)),
                      center: Text('${_correctPercent.toString()}%',style: TextStyle(color: Colors.white),),
                      animation: true,
                      animationDuration: 1000,
                      progressColor: Colors.lightGreenAccent,
                      backgroundColor: Colors.transparent,
                    ),
                    CircularPercentIndicator(
                      radius: 45,
                      lineWidth: 10,
                      percent: _incorrectPercent,
                      header: Text('INCORRECT ANSWERS',style: TextStyle(color: Colors.white)),
                      center: Text('${_incorrectPercent.toString()}%',style: TextStyle(color: Colors.white),),
                      animation: true,
                      animationDuration: 1000,
                      progressColor: const Color.fromARGB(255, 247, 6, 2),
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              )
            ],
          ),
        ), 
      ),
    );
  }
}