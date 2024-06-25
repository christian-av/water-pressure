// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      List<Map<String, dynamic>> fetchedUsers = await DatabaseHelper.instance.getUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print('Failed to fetch users: $e');
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await DatabaseHelper.instance.deleteUser(id);
      _fetchUsers(); // Refresh user list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  Future<void> _togglePasswordVisibility(int id) async {
    Map<String, dynamic>? userDetails = await DatabaseHelper.instance.getUserDetails(id);
    if (userDetails != null) {
      String username = userDetails['username'];
      String password = userDetails['password'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          bool showPassword = false;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('User Details'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username: $username'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Password: '),
                        Expanded(
                          child: Text(
                            showPassword ? password : '********',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Text(showPassword ? 'Hide' : 'Show'),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: GoogleFonts.leagueSpartan(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['username']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    _togglePasswordVisibility(user['id']);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteUser(user['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

