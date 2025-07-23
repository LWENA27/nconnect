import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user_adapter.dart';
import '../storage/hive_boxes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = 'Customer';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = '';

  Future<void> _registerUser() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() => error = 'Email required');
      return;
    }
    var box = await Hive.openBox<User>(HiveBoxes.userBox);
    if (box.values.any((u) => u.email == email)) {
      setState(() => error = 'User already exists');
      return;
    }
    final user = User(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      role: role,
      name: email.split('@')[0],
      email: email,
      phone: '',
      verified: role == 'Customer',
    );
    await box.put(user.uid, user);
    setState(() => error = '');
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _loginUser() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() => error = 'Email required');
      return;
    }
    var box = await Hive.openBox<User>(HiveBoxes.userBox);
    User? user;
    try {
      user = box.values.firstWhere((u) => u.email == email && u.role == role);
    } catch (e) {
      user = null;
    }
    if (user == null) {
      setState(() => error = 'User not found. Please register.');
      return;
    }
    setState(() => error = '');
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login/Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: role,
              items: ['Admin', 'Professional', 'Customer']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) {
                setState(() => role = val!);
              },
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(error, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _loginUser,
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
