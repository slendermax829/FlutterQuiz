import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/QuizPool.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/widgets/RandQuiz.dart';
import 'package:flutterquiz/widgets/TakeQuiz.dart';
class HomePage extends StatefulWidget {

  static QuizPool pool = QuizPool();

  final String userEmail;

  const new({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  
  final _pages = const [
    TakeQuiz(),
    RandQuiz(),
    Text('index 2 - Results'),
  ];

  final Map<String,Icon> _icons = const {
    'Quiz': Icon(Icons.search),
    'RandomQuiz': Icon(Icons.question_mark),
    'Results': Icon(Icons.book)
  };

  final Map<String,Icon> _selectedIcons = const{
    'Quiz': Icon(Icons.search, color: Colors.white,),
    'RandomQuiz': Icon(Icons.question_mark, color: Colors.white,),
    'Results': Icon(Icons.book, color: Colors.white,)
  };

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setToDefault());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('FlutterQuiz'),
        backgroundColor: const Color.fromARGB(139, 46, 45, 45),
        foregroundColor: Colors.white,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 175),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentPage),
          child: Center(child: Center(child: _pages[_currentPage]))
        )
      ),
      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              );
            }
            return const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            );
          }
        ),
        animationDuration: Duration(milliseconds: 200),
        backgroundColor: Color.fromARGB(205, 247, 247, 248),
        indicatorColor: Color.fromARGB(255, 26, 100, 238),
        selectedIndex: _currentPage,
        onDestinationSelected: (index) {
          setState(() => _currentPage = index);
        },
        destinations: [
          NavigationDestination(icon: _icons['Quiz']!, label: 'Available Quizzes', selectedIcon: _selectedIcons['Quiz'],),
          NavigationDestination(icon: _icons['RandomQuiz']!, label: 'Random Quiz', selectedIcon: _selectedIcons['RandomQuiz'],),
          NavigationDestination(icon: _icons['Results']!, label: 'Results', selectedIcon: _selectedIcons['Results'],),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 33, 117, 243)),
              accountName: Text(widget.userEmail.split('@')[0]),
              accountEmail: Text(widget.userEmail),
              currentAccountPicture: CircleAvatar(
                child: Text(widget.userEmail[0].toUpperCase()),
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(132, 0, 0, 0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
