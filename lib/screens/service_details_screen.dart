import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  late String currentUserId;
  List<dynamic> packages = [];
  List<dynamic> addons = [];
  String? selectedPackageId;
  Set<String> selectedAddonIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() => currentUserId = user.id);
      await Future.wait([
        _fetchPackages(),
        _fetchAddons(),
      ]);
    }
  }

  Future<void> _fetchPackages() async {
    try {
      final response = await Supabase.instance.client
          .from('service_packages')
          .select()
          .eq('service_id', widget.service['id']);

      if (mounted) {
        setState(() {
          packages = response;
          if (packages.isNotEmpty) {
            selectedPackageId = packages.first['id'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading packages: $e')),
        );
      }
    }
  }

  Future<void> _fetchAddons() async {
    try {
      final response = await Supabase.instance.client
          .from('service_addons')
          .select()
          .eq('service_id', widget.service['id']);

      if (mounted) {
        setState(() {
          addons = response;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading add-ons: $e')),
        );
      }
    }
  }

  double _calculateTotal() {
    double total = 0;

    // Add package price
    if (selectedPackageId != null) {
      final pkg = packages
          .firstWhere((p) => p['id'] == selectedPackageId, orElse: () => null);
      if (pkg != null) {
        total += (pkg['price'] as num).toDouble();
      }
    }

    // Add selected addons
    for (final addonId in selectedAddonIds) {
      final addon = addons.firstWhere((a) => a['id'] == addonId,
          orElse: () => null);
      if (addon != null) {
        total += (addon['price'] as num).toDouble();
      }
    }

    return total;
  }

  void _placeOrder() async {
    if (selectedPackageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a package')),
      );
      return;
    }

    try {
      // Get platform fee percentage
      final settingsResponse = await Supabase.instance.client
          .from('platform_settings')
          .select()
          .limit(1)
          .single();

      final platformFeePercentage =
          settingsResponse['platform_fee_percentage'] ?? 15.0;
      final basePrice = _calculateTotal();
      final platformFee = basePrice * (platformFeePercentage / 100);
      final totalAmount = basePrice + platformFee;

      // Create order
      final orderResponse = await Supabase.instance.client
          .from('orders')
          .insert({
            'customer_id': currentUserId,
            'service_id': widget.service['id'],
            'professional_id': widget.service['provider_id'],
            'package_type': packages
                .firstWhere((p) => p['id'] == selectedPackageId)['package_type'],
            'base_price': basePrice,
            'platform_fee_amount': platformFee,
            'total_amount': totalAmount,
            'delivery_time_days': widget.service['delivery_time_days'],
            'max_revisions': widget.service['max_revisions'],
            'status': 'pending',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      // Create escrow payment record
      await Supabase.instance.client.from('escrow_payments').insert({
        'order_id': orderResponse['id'],
        'customer_id': currentUserId,
        'professional_id': widget.service['provider_id'],
        'amount': totalAmount,
        'platform_fee_amount': platformFee,
        'professional_amount': basePrice,
        'status': 'held',
        'created_at': DateTime.now().toIso8601String(),
      });

      // Create transaction record
      await Supabase.instance.client.from('transactions').insert({
        'user_id': currentUserId,
        'type': 'order',
        'amount': totalAmount,
        'status': 'completed',
        'description': 'Order placed for ${widget.service['title']}',
        'related_order_id': orderResponse['id'],
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
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
          'Service Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Header
                  Container(
                    color: Colors.blue.shade50,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Image
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(Icons.image,
                                size: 64, color: Colors.grey.shade400),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title and Category
                        Text(
                          widget.service['title'] ?? 'Untitled Service',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Rating and Orders
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.service['rating_avg'] ?? 0} rating',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.shopping_bag,
                                color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.service['total_orders'] ?? 0} orders',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Description
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.service['description'] ??
                              'No description available',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        // Service Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoCard(
                              icon: Icons.schedule,
                              title: 'Delivery',
                              value:
                                  '${widget.service['delivery_time_days']} days',
                            ),
                            _buildInfoCard(
                              icon: Icons.replay,
                              title: 'Revisions',
                              value:
                                  '${widget.service['max_revisions']} included',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Packages Section
                  if (packages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Package',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...packages.map((package) {
                            final isSelected =
                                selectedPackageId == package['id'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(
                                      () => selectedPackageId = package['id']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: isSelected
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            package['package_type'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            package['description'] ?? '',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '\$${(package['price'] as num).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  // Addons Section
                  if (addons.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add-ons',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...addons.map((addon) {
                            final isSelected = selectedAddonIds.contains(addon['id']);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedAddonIds.remove(addon['id']);
                                    } else {
                                      selectedAddonIds.add(addon['id']);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: isSelected
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          addon['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '+\$${(addon['price'] as num).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (_) {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedAddonIds
                                                      .remove(addon['id']);
                                                } else {
                                                  selectedAddonIds
                                                      .add(addon['id']);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  // Order Summary and Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              _buildPriceLine('Package Price',
                                  _getPackagePrice(), false),
                              if (selectedAddonIds.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: _buildPriceLine('Add-ons',
                                      _getAddonsPrice(), false),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Divider(
                                    color: Colors.grey.shade300, height: 1),
                              ),
                              _buildPriceLine('Total',
                                  _calculateTotal(), true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Order Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  double _getPackagePrice() {
    if (selectedPackageId != null) {
      final pkg = packages
          .firstWhere((p) => p['id'] == selectedPackageId, orElse: () => null);
      if (pkg != null) {
        return (pkg['price'] as num).toDouble();
      }
    }
    return 0.0;
  }

  double _getAddonsPrice() {
    double total = 0;
    for (final addonId in selectedAddonIds) {
      final addon = addons.firstWhere((a) => a['id'] == addonId,
          orElse: () => null);
      if (addon != null) {
        total += (addon['price'] as num).toDouble();
      }
    }
    return total;
  }

  Widget _buildPriceLine(String label, double amount, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
            color: isBold ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
