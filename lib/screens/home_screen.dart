import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/service_adapter.dart';
import '../models/user_adapter.dart';
import '../storage/hive_boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Service> services = [];
  User? currentUser;

  String searchQuery = '';
  String selectedCategory = 'All';
  double maxPrice = 10000;

  List<String> get categories => ['All', ...{...services.map((s) => s.category)}];

  List<Service> get filteredServices {
    return services.where((s) {
      final matchesCategory = selectedCategory == 'All' || s.category == selectedCategory;
      final matchesPrice = s.rate <= maxPrice;
      final matchesSearch = searchQuery.isEmpty || s.category.toLowerCase().contains(searchQuery.toLowerCase()) || s.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesPrice && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadUserAndServices();
  }

  Future<void> _loadUserAndServices() async {
    var userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    // For demo, pick the first user
    setState(() {
      currentUser = userBox.values.isNotEmpty ? userBox.values.first : null;
    });
    var serviceBox = await Hive.openBox<Service>(HiveBoxes.serviceBox);
    setState(() {
      services = serviceBox.values.toList();
    });
  }

  Future<void> _showAddServiceDialog() async {
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final rateController = TextEditingController();
    final availabilityController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Service'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: categoryController, decoration: InputDecoration(labelText: 'Category')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
              TextField(controller: rateController, decoration: InputDecoration(labelText: 'Rate'), keyboardType: TextInputType.number),
              TextField(controller: availabilityController, decoration: InputDecoration(labelText: 'Availability')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (currentUser == null) return;
              final service = Service(
                providerId: currentUser!.uid,
                category: categoryController.text,
                description: descriptionController.text,
                rate: double.tryParse(rateController.text) ?? 0.0,
                availability: availabilityController.text,
                portfolio: [],
              );
              var box = await Hive.openBox<Service>(HiveBoxes.serviceBox);
              await box.add(service);
              setState(() {
                services.add(service);
              });
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home, color: Colors.blue),
            SizedBox(width: 8),
            Text('nconnect'),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.blue),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: Icon(Icons.admin_panel_settings, color: Colors.blue),
            onPressed: () => Navigator.pushNamed(context, '/admin'),
            tooltip: 'Admin Panel',
          ),
          IconButton(
            icon: Icon(Icons.receipt_long, color: Colors.blue),
            onPressed: () => Navigator.pushNamed(context, '/transactions'),
            tooltip: 'Transactions',
          ),
          IconButton(
            icon: Icon(Icons.reviews, color: Colors.blue),
            onPressed: () => Navigator.pushNamed(context, '/reviews'),
            tooltip: 'Reviews',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            if (currentUser != null)
              Card(
                margin: EdgeInsets.all(12),
                child: ListTile(
                  leading: Icon(Icons.account_circle, color: Colors.blue, size: 40),
                  title: Text(currentUser!.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${currentUser!.role} | ${currentUser!.email}'),
                  trailing: currentUser!.verified ? Icon(Icons.verified, color: Colors.green) : Icon(Icons.error, color: Colors.red),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => selectedCategory = val!),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Max Price',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => setState(() => maxPrice = double.tryParse(val) ?? 10000),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredServices.isEmpty
                  ? Center(child: Text('No services found.', style: TextStyle(color: Colors.grey, fontSize: 18)))
                  : ListView.separated(
                      itemCount: filteredServices.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: Icon(Icons.work, color: Colors.blue),
                            title: Text(service.category, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(service.description),
                            trailing: Text('${service.rate.toStringAsFixed(2)}', style: TextStyle(color: Colors.blue)),
                            onTap: () {
                              Navigator.pushNamed(context, '/service', arguments: service);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddServiceDialog,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Service',
      ),
    );
  }
}
