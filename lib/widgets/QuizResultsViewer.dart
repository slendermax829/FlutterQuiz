import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/QuizResults.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Displays the saved quiz results for the current user.
class QuizResultsViewer extends StatefulWidget {
  /// Creates a viewer for the current user's saved quiz results.
  const QuizResultsViewer({super.key});

  /// Creates the mutable state used to load and display quiz results.
  @override
  State<QuizResultsViewer> createState() => _QuizResultsViewerState();
}

class _QuizResultsViewerState extends State<QuizResultsViewer> {
  List<QuizResult> _results = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _displayDate(DateTime resultDate) => DateFormat.yMMMd().format(resultDate);

  /// Retrieves user results information
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('saved_username') ?? '';
    final results = await getUserResults(username);
    if (mounted) setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        margin: EdgeInsetsGeometry.all(15),
        padding: EdgeInsets.all(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color.fromARGB(84, 0, 0, 0),
            border: BoxBorder.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_results.isEmpty) ...[
                const Text('No results saved.', style: TextStyle(color: Colors.white),),
                const Text('Try taking a regular quiz or a random quiz', style: TextStyle(color: Colors.white))
              ]
              else ...[
                const Text('Your Results', style: TextStyle(color: Colors.white, fontSize: 24),),
                Expanded(
                  child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder:(context, index) {
                    final result = _results[index]; // curr result
                    return ListTile(
                      tileColor: Colors.transparent,
                      leading: CircleAvatar(
                        backgroundColor: result.score >= 70 ? Colors.lightGreenAccent : Colors.red,
                        foregroundColor: Colors.black,
                        child: Text('${result.score}'),
                      ),
                      title: Text('${result.quizName}', style: TextStyle(color: Colors.white, fontSize: 16),),
                      subtitle: Text(_displayDate(result.takenAt),style: TextStyle(color: Colors.white70, fontSize: 12)),
                      trailing: Text('Questions: ${result.correct} / ${result.total}',style: TextStyle(color: Colors.white70)),
                    );
                  },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}