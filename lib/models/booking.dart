import 'package:hive/hive.dart';

part 'booking.g.dart';

@HiveType(typeId: 2)
class Booking {
  @HiveField(0)
  final String bookingId;
  @HiveField(1)
  final String customerId;
  @HiveField(2)
  final String providerId;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String status; // pending, confirmed, completed, cancelled

  Booking({
    required this.bookingId,
    required this.customerId,
    required this.providerId,
    required this.date,
    required this.status,
  });
}
