import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction {
  @HiveField(0)
  final String transactionId;
  @HiveField(1)
  final String bookingId;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String status; // pending, escrow, released
  @HiveField(4)
  final DateTime timestamp;

  Transaction({
    required this.transactionId,
    required this.bookingId,
    required this.amount,
    required this.status,
    required this.timestamp,
  });
}
