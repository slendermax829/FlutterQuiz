import 'package:flutter/material.dart';
import 'package:flutterquiz/pages/TitlePage.dart';
import 'package:flutterquiz/widgets/Background.dart';
import 'package:flutterquiz/widgets/QuizResultsViewer.dart';
import 'package:flutterquiz/widgets/RandQuiz.dart';
import 'package:flutterquiz/widgets/TakeQuiz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterquiz/backend/QuizResults.dart';
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
    RandQuiz(),
    //Text('index 2 - Results'),
    QuizResultsViewer()
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

  Future<void> _confirmClearData() async{
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.blue.shade100,
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          title: Text('Clear Result Data?'),
          content: Text(
            'Do you want to clear your result data?',
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true), 
              child: Text('Confirm')
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue
              ),
              onPressed: () => Navigator.pop(context, false), 
              child: Text('Cancel')
            )
          ],
        );
      }
    );

    if((confirm ?? false) && mounted){
      try{
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('saved_username') ?? '';
      await clearUserResults(username);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted result data successfully!',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.lightGreen,
          duration: Duration(milliseconds: 500),
        )
      );

      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR deleting data: $e',style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 500),
          )
        );
      }
    }
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
              onTap: () async {
                
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();

                Navigator.push(
                  context, 
                  PageRouteBuilder(
                    pageBuilder:(context, animation, secondaryAnimation) => TitlePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child
                      );
                    },
                  )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.clear),
              title: const Text('Clear all result data'),
              onTap: () async {
                await _confirmClearData();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
