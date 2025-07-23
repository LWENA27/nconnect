import 'package:hive/hive.dart';

part 'service_adapter.g.dart';

@HiveType(typeId: 1)
class Service extends HiveObject {
  @HiveField(0)
  String providerId;
  @HiveField(1)
  String category;
  @HiveField(2)
  String description;
  @HiveField(3)
  double rate;
  @HiveField(4)
  String availability;
  @HiveField(5)
  List<String> portfolio;

  Service({
    required this.providerId,
    required this.category,
    required this.description,
    required this.rate,
    required this.availability,
    required this.portfolio,
  });
}
