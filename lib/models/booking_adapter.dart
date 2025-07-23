import 'package:hive/hive.dart';

part 'booking_adapter.g.dart';

@HiveType(typeId: 2)
class Booking extends HiveObject {
  @HiveField(0)
  String bookingId;
  @HiveField(1)
  String customerId;
  @HiveField(2)
  String providerId;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  String status;

  Booking({
    required this.bookingId,
    required this.customerId,
    required this.providerId,
    required this.date,
    required this.status,
  });
}
