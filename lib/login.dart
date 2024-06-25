import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.dart'; // Import the WaterPressureDashboard
import 'database_helper.dart'; // Import DatabaseHelper
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center( // Center the content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left)
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Water Pressure\nSensor Measurement App', // Wordmark added here
                  style: GoogleFonts.leagueSpartan(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left, // Align text to the left
                ),
              ),
              TextField(
                controller: _usernameController,
                style: GoogleFonts.leagueSpartan(color: Colors.black), // Set text color to black
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                style: GoogleFonts.leagueSpartan(color: Colors.black), // Set text color to black
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black), 
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(200, 50), // Set blue as the background color
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.leagueSpartan(
                    color: Colors.black, // Set text color to black
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Register Here',
                  style: GoogleFonts.leagueSpartan(
                    color: Colors.blue, // Set text color to blue
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Fetch user from database
    Map<String, dynamic>? user = await DatabaseHelper.instance.getUserByUsername(username);
    
    // Validate user credentials
    if (user != null && user['password'] == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WaterPressureDashboard()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
