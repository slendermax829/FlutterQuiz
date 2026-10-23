import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class QuizResult {
  final String username;
  final String quizName;
  final int score;
  final int correct;
  final int incorrect;
  final int total;
  final DateTime takenAt;

  const QuizResult({
    required this.username,
    required this.quizName,
    required this.score,
    required this.correct,
    required this.incorrect,
    required this.total,
    required this.takenAt,
  });

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

Future<void> clearUserResults(String username) async{
  final results = await _loadQuizResults();

  final file = await _resultsFile();

  await file.writeAsString(
    const JsonEncoder.withIndent('  ').convert([for (final r in results) if(r.username != username) r.toJson()]),
    flush: true,
  );
}
