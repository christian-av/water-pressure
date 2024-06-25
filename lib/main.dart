import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginPage
import 'dashboard.dart'; // Import the WaterPressureDashboard

void main() {
  runApp(WaterPressureApp());
}

class WaterPressureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Pressure App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'LeagueSpartan',
      ),
      home: LoginPage(),
      routes: {
        '/overview': (context) => WaterPressureDashboard(),
      },
    );
  }
}
