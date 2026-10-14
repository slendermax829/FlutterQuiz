import 'package:flutter/material.dart';
import 'package:flutterquiz/widgets/TakeQuiz.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const new({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  final _pages = const [
    TakeQuiz(),
    Text('index 1 - RandomQuiz'),
    Text('index 2 - Results'),
  ];

  final Map<String,Icon> _icons = const {
    'Quiz': Icon(Icons.search),
    'RandomQuiz': Icon(Icons.question_mark),
    'Results': Icon(Icons.book)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('FlutterQuiz'),
        backgroundColor: const Color.fromARGB(139, 46, 45, 45),
        foregroundColor: Colors.white,
      ),
      body: Center(child: Center(child: _pages[_currentPage])),
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration(milliseconds: 200),
        backgroundColor: Color.fromARGB(205, 247, 247, 248),
        indicatorColor: Color.fromARGB(255, 26, 100, 238),
        selectedIndex: _currentPage,
        onDestinationSelected: (index) {
          setState(() => _currentPage = index);
        },
        destinations: [
          NavigationDestination(icon: _icons['Quiz']!, label: 'Take a Quiz'),
          NavigationDestination(icon: _icons['RandomQuiz']!, label: 'Take a Random Quiz'),
          NavigationDestination(icon: _icons['Results']!, label: 'Results'),
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
