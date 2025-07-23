import 'package:hive/hive.dart';

part 'service.g.dart';

@HiveType(typeId: 1)
class Service {
  @HiveField(0)
  final String providerId;
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final double rate;
  @HiveField(4)
  final String availability;
  @HiveField(5)
  final List<String> portfolio; // file paths or URLs

  Service({
    required this.providerId,
    required this.category,
    required this.description,
    required this.rate,
    required this.availability,
    required this.portfolio,
  });
}
