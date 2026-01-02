import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/service_adapter.dart';
import '../models/user_adapter.dart';
import '../models/booking_adapter.dart';
import '../storage/hive_boxes.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<User> professionals = [];
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    var bookingBox = await Hive.openBox<Booking>(HiveBoxes.bookingBox);
    setState(() {
      professionals = userBox.values
          .where((u) => u.role == 'Professional')
          .toList();
      bookings = bookingBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
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
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify Professionals',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ...professionals.map(
                      (p) => ListTile(
                        leading: Icon(Icons.account_circle, color: Colors.blue),
                        title: Text(p.name),
                        subtitle: Text(p.email),
                        trailing: p.verified
                            ? Icon(Icons.check, color: Colors.green)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  p.verified = true;
                                  await p.save();
                                  setState(() {});
                                },
                                child: Text('Verify'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bookings & Disputes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ...bookings.map(
                      (b) => ListTile(
                        leading: Icon(Icons.book_online, color: Colors.blue),
                        title: Text('Booking: ${b.bookingId}'),
                        subtitle: Text('Status: ${b.status}'),
                        trailing: b.status == 'dispute'
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  b.status = 'resolved';
                                  await b.save();
                                  setState(() {});
                                },
                                child: Text('Resolve'),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
