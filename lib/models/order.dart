import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 9)
class Order {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String customerId;
  
  @HiveField(2)
  final String serviceId;
  
  @HiveField(3)
  final String professionalId;
  
  @HiveField(4)
  final String packageType; // 'Basic', 'Standard', 'Premium'
  
  @HiveField(5)
  final double basePrice;
  
  @HiveField(6)
  final List<OrderAddon> addons;
  
  @HiveField(7)
  final double platformFeeAmount;
  
  @HiveField(8)
  final double totalAmount;
  
  @HiveField(9)
  final DateTime createdAt;
  
  @HiveField(10)
  final DateTime? deliveryDeadline;
  
  @HiveField(11)
  final String status; // 'pending', 'accepted', 'in_progress', 'submitted', 'confirmed', 'completed', 'cancelled'
  
  @HiveField(12)
  final DateTime? acceptedAt;
  
  @HiveField(13)
  final DateTime? completedAt;

  Order({
    required this.id,
    required this.customerId,
    required this.serviceId,
    required this.professionalId,
    required this.packageType,
    required this.basePrice,
    required this.addons,
    required this.platformFeeAmount,
    required this.totalAmount,
    required this.createdAt,
    this.deliveryDeadline,
    this.status = 'pending',
    this.acceptedAt,
    this.completedAt,
  });
}

@HiveType(typeId: 10)
class OrderAddon {
  @HiveField(0)
  final String addonId;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final double price;

  OrderAddon({
    required this.addonId,
    required this.title,
    required this.price,
  });
}

@HiveType(typeId: 11)
class EscrowPayment {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String orderId;
  
  @HiveField(2)
  final String customerId;
  
  @HiveField(3)
  final String professionalId;
  
  @HiveField(4)
  final double amount;
  
  @HiveField(5)
  final double platformFeeAmount;
  
  @HiveField(6)
  final double professionalAmount;
  
  @HiveField(7)
  final String status; // 'held', 'released', 'refunded'
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime? releasedAt;
  
  @HiveField(10)
  final String? adminNotes;

  EscrowPayment({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.professionalId,
    required this.amount,
    required this.platformFeeAmount,
    required this.professionalAmount,
    this.status = 'held',
    required this.createdAt,
    this.releasedAt,
    this.adminNotes,
  });
}

@HiveType(typeId: 12)
class Transaction {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String type; // 'order', 'payment', 'withdrawal', 'refund'
  
  @HiveField(3)
  final double amount;
  
  @HiveField(4)
  final String status; // 'pending', 'completed', 'failed'
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  final String? description;
  
  @HiveField(7)
  final String? relatedOrderId;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.status = 'pending',
    required this.createdAt,
    this.description,
    this.relatedOrderId,
  });
}

@HiveType(typeId: 13)
class WithdrawalRequest {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String professionalId;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final String status; // 'pending', 'approved', 'rejected', 'completed'
  
  @HiveField(4)
  final DateTime requestedAt;
  
  @HiveField(5)
  final DateTime? approvedAt;
  
  @HiveField(6)
  final DateTime? completedAt;
  
  @HiveField(7)
  final String? adminNotes;

  WithdrawalRequest({
    required this.id,
    required this.professionalId,
    required this.amount,
    this.status = 'pending',
    required this.requestedAt,
    this.approvedAt,
    this.completedAt,
    this.adminNotes,
  });
}

@HiveType(typeId: 14)
class TaskSubmission {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String orderId;
  
  @HiveField(2)
  final String professionalId;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final List<String> attachmentUrls;
  
  @HiveField(5)
  final DateTime submittedAt;
  
  @HiveField(6)
  final String status; // 'submitted', 'revision_requested', 'confirmed'
  
  @HiveField(7)
  final String? revisionNotes;
  
  @HiveField(8)
  final int revisionNumber;

  TaskSubmission({
    required this.id,
    required this.orderId,
    required this.professionalId,
    required this.description,
    required this.attachmentUrls,
    required this.submittedAt,
    this.status = 'submitted',
    this.revisionNotes,
    this.revisionNumber = 1,
  });
}

@HiveType(typeId: 15)
class Review {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String orderId;
  
  @HiveField(2)
  final String reviewerId;
  
  @HiveField(3)
  final String revieweeId;
  
  @HiveField(4)
  final double rating; // 1-5
  
  @HiveField(5)
  final String comment;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final String reviewType; // 'service', 'professional', 'customer'

  Review({
    required this.id,
    required this.orderId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewType,
  });
}
