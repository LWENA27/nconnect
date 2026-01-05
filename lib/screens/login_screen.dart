import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  String error = '';
  String successMessage = '';
  bool isLoading = false;
  String selectedRole = 'Customer';
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        error = 'Full Name, Email, and Password required';
        successMessage = '';
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user != null) {
        // Store user in Supabase 'users' table with role
        await supabase.from('users').insert({
          'uid': res.user!.id,
          'full_name': fullName,
          'email': email,
          'phone_number': phone,
          'primary_role': selectedRole,
        });

        setState(() {
          error = '';
          successMessage = 'Registration successful! Please log in.';
          isLoading = false;
        });

        // Clear form
        fullNameController.clear();
        emailController.clear();
        passwordController.clear();
        phoneController.clear();

        // Switch to login tab
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            _tabController.animateTo(0);
            loginEmailController.text = email;
          }
        });
      }
    } on AuthException catch (e) {
      setState(() {
        error = e.message;
        successMessage = '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'An unexpected error occurred: ${e.toString()}';
        successMessage = '';
        isLoading = false;
      });
    }
  }

  Future<void> _loginUser() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        error = 'Email and Password required';
        successMessage = '';
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        // Fetch user's primary role from database
        final userData = await supabase
            .from('users')
            .select('primary_role')
            .eq('uid', res.user!.id)
            .single();

        final primaryRole = userData['primary_role'] ?? 'Customer';

        setState(() {
          error = '';
          successMessage = '';
          isLoading = false;
        });

        // Redirect to role-specific page
        if (mounted) {
          if (primaryRole == 'Professional') {
            Navigator.pushReplacementNamed(context, '/professional-dashboard');
          } else if (primaryRole == 'Admin') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/customer-dashboard');
          }
        }
      }
    } on AuthException catch (e) {
      setState(() {
        error = e.message;
        successMessage = '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'An unexpected error occurred: ${e.toString()}';
        successMessage = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nconnect'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Tab(
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Login Tab
                _buildLoginTab(),
                // Register Tab
                _buildRegisterTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          Icon(Icons.login, size: 48, color: Colors.blue),
          SizedBox(height: 24),
          Text(
            'Welcome Back',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Login to your account',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 32),
          TextField(
            controller: loginEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          TextField(
            controller: loginPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
          ),
          if (error.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : _loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      'Login',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? "),
              GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: Text(
                  'Register here',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          Icon(Icons.person_add, size: 48, color: Colors.blue),
          SizedBox(height: 24),
          Text(
            'Create Account',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Join nconnect today',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 32),
          TextField(
            controller: fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'John Doe',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedRole,
              padding: EdgeInsets.symmetric(horizontal: 12),
              underline: SizedBox(),
              items: [
                'Customer',
                'Professional',
              ].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedRole = value);
                }
              },
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1 (555) 000-0000',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'At least 6 characters',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
          ),
          if (error.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (successMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        successMessage,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      'Register',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? "),
              GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Text(
                  'Login here',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
