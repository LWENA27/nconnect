import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  late String currentUserId;
  List<dynamic> services = [];
  List<dynamic> categories = [];
  String? selectedCategory;
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() => currentUserId = user.id);
      await Future.wait([
        _fetchCategories(),
        _fetchServices(),
      ]);
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response =
          await Supabase.instance.client.from('categories').select();

      if (mounted) {
        setState(() => categories = response);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  Future<void> _fetchServices() async {
    try {
      var query = Supabase.instance.client
          .from('services')
          .select(
              'id, provider_id, category_id, title, description, delivery_time_days, max_revisions, rating_avg, total_orders, categories(name)')
          .eq('status', 'active');

      if (selectedCategory != null && selectedCategory!.isNotEmpty) {
        query = query.eq('category_id', selectedCategory!);
      }

      final response = await query;

      if (mounted) {
        setState(() {
          services = response
              .where((service) =>
                  service['provider_id'] !=
                  currentUserId) // Exclude own services
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading services: $e')),
        );
      }
    }
  }

  void _switchRole() async {
    try {
      await Supabase.instance.client.from('users').update({
        'primary_role': 'Professional',
      }).eq('uid', currentUserId);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/professional-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error switching role: $e')),
        );
      }
    }
  }

  void _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Browse Services',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Switch Role Button
          Tooltip(
            message: 'Switch to Professional',
            child: IconButton(
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              onPressed: _switchRole,
            ),
          ),
          // Profile Button
          Tooltip(
            message: 'Profile',
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () => Navigator.of(context).pushNamed('/profile'),
            ),
          ),
          // Logout Button
          Tooltip(
            message: 'Logout',
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Welcome Section
                  Container(
                    color: Colors.blue.shade50,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to nConnect',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Browse and order services from professional providers',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Filters Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Services',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        // Category Filter
                        SizedBox(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: const Text('All'),
                                    selected: selectedCategory == null,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                            () => selectedCategory = null);
                                        _fetchServices();
                                      }
                                    },
                                  ),
                                );
                              }
                              final category = categories[index - 1];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category['name']),
                                  selected:
                                      selectedCategory == category['id'],
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() =>
                                          selectedCategory = category['id']);
                                      _fetchServices();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Services Grid
                  if (services.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'No services found',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return _buildServiceCard(service);
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildServiceCard(dynamic service) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/service-details',
          arguments: service,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image Placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.image,
                    size: 48, color: Colors.blue.shade300),
              ),
            ),
            // Service Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['title'] ?? 'Untitled Service',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['categories'] != null
                              ? service['categories']['name']
                              : 'Category',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    // Rating and Orders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              (service['rating_avg'] ?? 0).toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          '${service['total_orders'] ?? 0} orders',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
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
