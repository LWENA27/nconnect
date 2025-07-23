import 'package:hive/hive.dart';

part 'transaction_adapter.g.dart';

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  @HiveField(0)
  String transactionId;
  @HiveField(1)
  String bookingId;
  @HiveField(2)
  double amount;
  @HiveField(3)
  String status;
  @HiveField(4)
  DateTime timestamp;

  Transaction({
    required this.transactionId,
    required this.bookingId,
    required this.amount,
    required this.status,
    required this.timestamp,
  });
}
