import 'package:hive/hive.dart';

part 'service.g.dart';

@HiveType(typeId: 1)
class Service {
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
  final List<ServicePackage> packages;
  
  @HiveField(11)
  final List<ServiceAddon> addons;

  Service({
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

@HiveType(typeId: 6)
class ServicePackage {
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

  ServicePackage({
    required this.id,
    required this.serviceId,
    required this.packageType,
    required this.price,
    required this.description,
    this.features = const [],
  });
}

@HiveType(typeId: 7)
class ServiceAddon {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String serviceId;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final double price;

  ServiceAddon({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.price,
  });
}

@HiveType(typeId: 8)
class Category {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String? iconUrl;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
  });
}
