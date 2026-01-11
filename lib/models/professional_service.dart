import 'package:hive/hive.dart';

@HiveType(typeId: 9)
class ProfessionalService {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String providerId;
  
  @HiveField(2)
  final String categoryId;
  
  @HiveField(3)
  final String title;
  
  @HiveField(4)
  final String description;
  
  @HiveField(5)
  final int deliveryTimeDays;
  
  @HiveField(6)
  final int maxRevisions;
  
  @HiveField(7)
  final String status; // 'active', 'paused', 'archived'
  
  @HiveField(8)
  final double ratingAvg;
  
  @HiveField(9)
  final int totalOrders;
  
  @HiveField(10)
  final List<ProfessionalServicePackage> packages;
  
  @HiveField(11)
  final List<ProfessionalServiceAddon> addons;

  ProfessionalService({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.deliveryTimeDays,
    required this.maxRevisions,
    this.status = 'active',
    this.ratingAvg = 0.0,
    this.totalOrders = 0,
    this.packages = const [],
    this.addons = const [],
  });
}

@HiveType(typeId: 10)
class ProfessionalServicePackage {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String serviceId;
  
  @HiveField(2)
  final String packageType; // 'Basic', 'Standard', 'Premium'
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final String description;
  
  @HiveField(5)
  final List<String> features;

  ProfessionalServicePackage({
    required this.id,
    required this.serviceId,
    required this.packageType,
    required this.price,
    required this.description,
    this.features = const [],
  });
}

@HiveType(typeId: 11)
class ProfessionalServiceAddon {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String serviceId;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final double price;

  ProfessionalServiceAddon({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.price,
  });
}
