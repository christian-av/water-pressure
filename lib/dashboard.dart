import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'database_helper.dart';
import 'login.dart';
import 'usermanagement.dart'; // Import UserManagement Page

void main() {
  runApp(MaterialApp(
    title: 'Water Pressure Sensor',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: WaterPressureDashboard(),
  ));
}

class WaterPressureDashboard extends StatefulWidget {
  @override
  _WaterPressureDashboardState createState() => _WaterPressureDashboardState();
}

class _WaterPressureDashboardState extends State<WaterPressureDashboard> {
  String selectedPage = 'Home';
  String pressureResult = '';
  List<Map<String, String>> pressureLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchPressureLogs(); // Fetch pressure logs from database on widget initialization
  }

  void _fetchPressureLogs() async {
    try {
      List<Map<String, dynamic>> logs = await DatabaseHelper.instance.getPressureLogs();
      setState(() {
        pressureLogs = logs.map((log) => {
          'id': log['id'].toString(),
          'timestamp': log['timestamp'].toString(),
          'pressure': log['pressure'].toString(),
        }).toList();
      });
    } catch (e) {
      print('Failed to fetch pressure logs: $e');
    }
  }

  void _measurePressure(BuildContext context) {
    setState(() {
      pressureResult = 'Measuring Water Pressure...';
    });

    Future.delayed(Duration(seconds: 2), () {
      double simulatedPressure = Random().nextInt(171) + 30;

      setState(() {
        pressureResult = 'Water Pressure: $simulatedPressure PSI';
        pressureLogs.add({
          'timestamp': DateTime.now().toString(),
          'pressure': '$simulatedPressure PSI'
        });
      });

      // Save pressure log to database
      _savePressureLogToDatabase({
        'timestamp': DateTime.now().toString(),
        'pressure': '$simulatedPressure PSI'
      });

      final resultSnackBar = SnackBar(
        content: Text('Water Pressure: $simulatedPressure PSI'),
      );

      ScaffoldMessenger.of(context).showSnackBar(resultSnackBar);
    });
  }

  void _savePressureLogToDatabase(Map<String, dynamic> log) async {
    try {
      int id = await DatabaseHelper.instance.insertPressureLog(log);
      print('Pressure log saved with id: $id');
    } catch (e) {
      print('Failed to save pressure log: $e');
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _clearLogs() async {
    try {
      await DatabaseHelper.instance.clearPressureLogs();
      setState(() {
        pressureLogs.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All pressure logs cleared')),
      );
    } catch (e) {
      print('Failed to clear pressure logs: $e');
    }
  }

  void _deleteLog(int index) async {
    int id = int.parse(pressureLogs[index]['id']!);
    String logPressure = pressureLogs[index]['pressure']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this pressure log: $logPressure?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await DatabaseHelper.instance.deletePressureLog(id);
                  setState(() {
                    pressureLogs.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pressure log deleted')),
                  );
                } catch (e) {
                  print('Failed to delete pressure log: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Pressure Sensor',
          style: GoogleFonts.leagueSpartan(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      drawer: Drawer(
        child: SafeArea( // Ensures drawer content stays within safe area boundaries
          child: Container(
            color: Colors.grey[500],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Water Pressure\nSensor Measurement App', // Wordmark added here
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedPage = 'Home';
                      });
                    },
                    hoverColor: Colors.black,
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedPage == 'Home' ? Colors.grey[850] : Colors.transparent,
                      ),
                      child: ListTile(
                        title: Text(
                          'Home',
                          style: GoogleFonts.leagueSpartan(
                            color: selectedPage == 'Home' ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.show_chart,
                    color: Colors.black,
                  ),
                  title: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedPage = 'Pressure Scan History';
                      });
                    },
                    hoverColor: Colors.black,
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedPage == 'Pressure Scan History' ? Colors.grey[850] : Colors.transparent,
                      ),
                      child: ListTile(
                        title: Text(
                          'Pressure Scan History',
                          style: GoogleFonts.leagueSpartan(
                            color: selectedPage == 'Pressure Scan History' ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.analytics,
                    color: Colors.black,
                  ),
                  title: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedPage = 'Settings';
                      });
                    },
                    hoverColor: Colors.black,
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedPage == 'Settings' ? Colors.grey[850] : Colors.transparent,
                      ),
                      child: ListTile(
                        title: Text(
                          'Settings',
                          style: GoogleFonts.leagueSpartan(
                            color: selectedPage == 'Settings' ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _logout(context);
                    },
                    hoverColor: Colors.black,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red[50],
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.leagueSpartan(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[500],
        child: Center(
          child: selectedPage == 'Settings'
              ? SettingsPage()
              : selectedPage == 'Pressure Scan History'
                  ? PressureScanHistory(
                      pressureLogs: pressureLogs,
                      clearLogsCallback: _clearLogs,
                      deleteLogCallback: _deleteLog,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pressureResult.isNotEmpty ? pressureResult : 'Welcome to the Dashboard!',
                          style: GoogleFonts.leagueSpartan(),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _measurePressure(context);
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                            fixedSize: Size(200, 50),
                          ),
                          child: Text(
                            'Measure Water Pressure',
                            style: GoogleFonts.leagueSpartan(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class PressureScanHistory extends StatefulWidget {
  final List<Map<String, String>> pressureLogs;
  final Function clearLogsCallback;
  final Function deleteLogCallback;

  const PressureScanHistory({
    Key? key,
    required this.pressureLogs,
    required this.clearLogsCallback,
    required this.deleteLogCallback,
  }) : super(key: key);

  @override
  _PressureScanHistoryState createState() => _PressureScanHistoryState();
}

class _PressureScanHistoryState extends State<PressureScanHistory> {
  void _deleteLog(int index) async {
    int id = int.parse(widget.pressureLogs[index]['id']!);
    String logPressure = widget.pressureLogs[index]['pressure']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this pressure log: $logPressure?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await DatabaseHelper.instance.deletePressureLog(id);
                  setState(() {
                    widget.pressureLogs.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pressure log deleted')),
                  );
                } catch (e) {
                  print('Failed to delete pressure log: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pressure Scan History',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.clearLogsCallback();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Text('Clear Logs'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.pressureLogs.length,
              itemBuilder: (context, index) {
                final log = widget.pressureLogs[index];
                DateTime logDateTime = DateTime.parse(log['timestamp']!);
                String formattedDateTime =
                    '${DateFormat('MM/dd/yyyy').format(logDateTime)} ${_formatTimeOfDay(logDateTime)}';
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(log['pressure']!, style: GoogleFonts.leagueSpartan()),
                    subtitle: Text(formattedDateTime, style: GoogleFonts.leagueSpartan()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteLog(index); // Call _deleteLog with the index of the log to delete
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(DateTime dateTime) {
    final timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return '${timeOfDay.hourOfPeriod}:${timeOfDay.minute.toString().padLeft(2, '0')} ${timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}';
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.black,
            ),
            title: Text(
              'User Management',
              style: GoogleFonts.leagueSpartan(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserManagement()),
              );
            },
          ),
        ],
      ),
    );
  }
}
