import 'package:flutter/material.dart';
import 'package:flutterquiz/backend/QuizService.dart' as qs;
import 'package:flutterquiz/pages/LoadingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ({String username, String password}) get _fields =>
      (username: _userController.text, password: _passwordController.text);

  void _checkForm() async {
    var username = _fields.username.split('@')[0];
    var pin = int.parse(_fields.password);

    var loginResponse = await qs.validateUser(username: username, pin: pin);

    if(loginResponse.response){
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_username', username);

      //Navigator.push(context, MaterialPageRoute(builder: (context)=> LoadingPage(userEmail: _userController.text)));
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:(context, animation, secondaryAnimation) => LoadingPage(userEmail: _userController.text),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 300)
        )
      );
    }else{
      displayMessage('LOGIN FAILED', Colors.red);
    }
  }

  void displayMessage(String message, [Color color = Colors.amberAccent]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.black)),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsetsGeometry.all(20),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(64, 0, 0, 0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          child: Column(
            spacing: 35,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'User Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _userController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'cs4381@miners.utep.edu',
                  hintStyle: TextStyle(color: Color.fromARGB(175, 247, 247, 249)),
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
                    return 'Email must be filled out.';
                  }
                  if (!RegExp('@miners.utep.edu').hasMatch(value)) {
                    return 'Email must contain \'@miners.utep.edu\'';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                obscureText: true,
                decoration: InputDecoration(
                  iconColor: Colors.white,
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Last 4 digits of your ID eg. 8000xxxx',
                  hintStyle: TextStyle(color: Color.fromARGB(175, 247, 247, 249)),
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
                    return 'Password must be filled out.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Password must be numerical.';
                  }
                  return null;
                },
              ),
              Builder(
                builder: (context) {
                  return Row(
                    children: [
                      ElevatedButton(
                        child: Text('Log in'),
                        onPressed: () {
                          if (Form.of(context).validate()) {
                            _checkForm();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
