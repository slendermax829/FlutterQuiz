import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Stores a user's score and answer counts for a completed quiz.
class QuizResult {
  /// The username associated with this result.
  final String username;

  /// The name of the completed quiz.
  final String quizName;

  /// The score earned on the quiz.
  final int score;

  /// The number of questions answered correctly.
  final int correct;

  /// The number of questions answered incorrectly.
  final int incorrect;

  /// The total number of questions in the quiz.
  final int total;

  /// The date and time the quiz was taken.
  final DateTime takenAt;

  /// Creates a result record with all quiz and score details.
  const QuizResult({
    required this.username,
    required this.quizName,
    required this.score,
    required this.correct,
    required this.incorrect,
    required this.total,
    required this.takenAt,
  });

  /// Creates a result record from JSON data.
  ///
  /// Missing or invalid fields are replaced with default values.
  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        username: json['username'] as String? ?? '',
        quizName: json['quizName'] as String? ?? '',
        score: json['score'] as int? ?? 0,
        correct: json['correct'] as int? ?? 0,
        incorrect: json['incorrect'] as int? ?? 0,
        total: json['total'] as int? ?? 0,
        takenAt: DateTime.tryParse(json['takenAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );

  /// Converts this result record to JSON-compatible data.
  Map<String, dynamic> toJson() => {
        'username': username,
        'quizName': quizName,
        'score': score,
        'correct': correct,
        'incorrect': incorrect,
        'total': total,
        'takenAt': takenAt.toIso8601String(),
      };
}

const String _fileName = 'quiz_results.json';

Future<File> _resultsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_fileName');
}

/// Loads all saved results; a missing or corrupt file yields an empty list.
Future<List<QuizResult>> _loadQuizResults() async {
  try {
    final file = await _resultsFile();

    if (!await file.exists()){
      return [];
    }

    final data = jsonDecode(await file.readAsString());
    if (data is! List) return [];

    return [
      for (final item in data)
        if (item is Map<String, dynamic>) QuizResult.fromJson(item),
    ];

  } on FileSystemException {
    return [];
  } on FormatException {
    return [];
  }
}

/// Appends [result] to the JSON file, creating it if needed.
Future<void> saveQuizResult(QuizResult result) async {
  final results = await _loadQuizResults();
  results.add(result);

  final file = await _resultsFile();
  await file.writeAsString(
    const JsonEncoder.withIndent('  ').convert([for (final r in results) r.toJson()]),
    flush: true,
  );
}

/// Returns the saved quiz results belonging to [username].
///
/// Returns an empty list when the results file is missing or cannot be parsed.
Future<List<QuizResult>> getUserResults(String username) async{
  try{
    final file = await _resultsFile();
    if(!await file.exists()){
      return [];
    }

    final data = jsonDecode(await file.readAsString());
    if(data is! List){
      return [];
    }

    var list = [
      for(var entry in data)
        if (entry is Map<String, dynamic>) QuizResult.fromJson(entry)
    ];

    return list.where((result)=> result.username == username).toList();
  } on FileSystemException {
    return [];
  } on FormatException {
    return [];
  }
}

/// Removes all saved quiz results belonging to [username].
Future<void> clearUserResults(String username) async{
  final results = await _loadQuizResults();

  final file = await _resultsFile();

  await file.writeAsString(
    const JsonEncoder.withIndent('  ').convert([for (final r in results) if(r.username != username) r.toJson()]),
    flush: true,
  );
}
