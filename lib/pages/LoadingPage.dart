import 'package:flutter/material.dart';
import 'package:flutterquiz/pages/HomePage.dart';
import 'package:flutterquiz/backend/QuizPool.dart' as pool;

class LoadingPage extends StatefulWidget {
  final String userEmail;

  const LoadingPage({super.key, required this.userEmail});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    if (_failed) setState(() => _failed = false);

    try {
      await pool.repopulate();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
      return;
    }

    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(userEmail: widget.userEmail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(130, 0, 0, 0),
      body: Center(
        child: _failed
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Could not load quizzes.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchQuizzes,
                    child: const Text('Retry'),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fetching Quizzes...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
