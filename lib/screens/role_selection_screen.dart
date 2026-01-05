import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final supabase = Supabase.instance.client;
  String? currentRole;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentRole();
  }

  Future<void> _loadCurrentRole() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final data = await supabase
            .from('users')
            .select('primary_role')
            .eq('uid', user.id)
            .single();
        setState(() => currentRole = data['primary_role']);
      }
    } catch (e) {
      print('Error loading current role: $e');
    }
  }

  Future<void> _switchRole(String newRole) async {
    setState(() => isLoading = true);
    try {
      await supabase
          .from('users')
          .update({'primary_role': newRole})
          .eq('uid', supabase.auth.currentUser!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to $newRole role'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to appropriate screen based on selected role
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            if (newRole == 'Professional') {
              Navigator.pushReplacementNamed(context, '/professional-dashboard');
            } else if (newRole == 'Admin') {
              Navigator.pushReplacementNamed(context, '/admin');
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error switching role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Switch Role'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24),
                    Icon(
                      Icons.person_outline,
                      size: 64,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Select Your Role',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Current Role: ${currentRole ?? 'Loading...'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 48),
                    _buildRoleCard(
                      'Customer',
                      Icons.shopping_bag,
                      'Browse and book services',
                      Colors.blue,
                    ),
                    SizedBox(height: 16),
                    _buildRoleCard(
                      'Professional',
                      Icons.work,
                      'Offer your services',
                      Colors.green,
                    ),
                    SizedBox(height: 16),
                    _buildRoleCard(
                      'Admin',
                      Icons.admin_panel_settings,
                      'Manage the platform',
                      Colors.purple,
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRoleCard(
    String role,
    IconData icon,
    String description,
    Color color,
  ) {
    final isCurrentRole = currentRole == role;
    return GestureDetector(
      onTap: isCurrentRole ? null : () => _switchRole(role),
      child: Card(
        elevation: isCurrentRole ? 4 : 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentRole ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                SizedBox(height: 16),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                if (isCurrentRole)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Current',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Switch to this role',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
