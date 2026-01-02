import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/service_adapter.dart';
import '../models/booking_adapter.dart';
import '../storage/hive_boxes.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)?.settings.arguments as Service?;
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Service'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 1,
      ),
      body: service == null
          ? Center(child: Text('No service selected.'))
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
                        Text(
                          'Booking for: ${service.category}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                          title: Text('Select Date'),
                          subtitle: Text(
                            selectedDate.toLocal().toString().split(' ')[0],
                          ),
                          trailing: Icon(Icons.edit),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            final booking = Booking(
                              bookingId: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              customerId: 'demo_customer',
                              providerId: service.providerId,
                              date: selectedDate,
                              status: 'confirmed',
                            );
                            var box = await Hive.openBox<Booking>(
                              HiveBoxes.bookingBox,
                            );
                            await box.put(booking.bookingId, booking);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Booking confirmed!')),
                            );
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.check),
                          label: Text('Confirm Booking'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            final booking = Booking(
                              bookingId: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              customerId: 'demo_customer',
                              providerId: service.providerId,
                              date: selectedDate,
                              status: 'dispute',
                            );
                            var box = await Hive.openBox<Booking>(
                              HiveBoxes.bookingBox,
                            );
                            await box.put(booking.bookingId, booking);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Booking marked as dispute!'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.report_problem),
                          label: Text('Report Dispute'),
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
