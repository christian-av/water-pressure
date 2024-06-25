import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _showPassword = false;

  void _register(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text('Passwords do not match. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Insert user into database
    Map<String, dynamic> user = {
      'username': username,
      'password': password,
    };

    try {
      await DatabaseHelper.instance.insertUser(user);
      
      // Show registration success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('You have successfully registered.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text('Error occurred while registering. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              style: GoogleFonts.leagueSpartan(color: Colors.black), // Set text color to black
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              style: GoogleFonts.leagueSpartan(color: Colors.black), // Set text color to black
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
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
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_showPassword,
              style: GoogleFonts.leagueSpartan(color: Colors.black), // Set text color to black
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(
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
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.black), backgroundColor: Colors.blue,
                fixedSize: Size(200, 50), // Set blue as the background color
              ),
              child: Text(
                'Register',
                style: GoogleFonts.leagueSpartan(
                  color: Colors.black, // Set text color to black
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Already have an account? Login Here',
                style: GoogleFonts.leagueSpartan(
                  color: Colors.blue, // Set text color to blue
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
