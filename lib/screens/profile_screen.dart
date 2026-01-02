import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_adapter.dart';
import '../storage/hive_boxes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual user info
    final String userId = 'demo_customer';
    return FutureBuilder<Box<User>>(
      future: Hive.openBox<User>(HiveBoxes.userBox),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data!.get(userId);
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            elevation: 1,
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: Colors.red),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                tooltip: 'Logout',
              ),
            ],
          ),
          body: user == null
              ? Center(child: Text('No user found.'))
              : Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Email: ${user.email}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Phone: ${user.phone}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Role: ${user.role}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Verified: ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                user.verified
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.error, color: Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
