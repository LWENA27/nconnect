import 'package:flutter/material.dart';
import '../models/service_adapter.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as Service?;
    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Service Details')),
        body: Center(child: Text('No service selected.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(service.category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 1,
      ),
      body: Container(
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
                  Text(service.description, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.blue),
                      SizedBox(width: 4),
                      Text('Rate: ${service.rate.toStringAsFixed(2)}', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 4),
                      Text('Availability: ${service.availability}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(context, '/booking', arguments: service);
                    },
                    icon: Icon(Icons.book_online),
                    label: Text('Book Service'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
