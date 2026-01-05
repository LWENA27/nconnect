// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 9;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as String,
      customerId: fields[1] as String,
      serviceId: fields[2] as String,
      professionalId: fields[3] as String,
      packageType: fields[4] as String,
      basePrice: fields[5] as double,
      addons: (fields[6] as List).cast<OrderAddon>(),
      platformFeeAmount: fields[7] as double,
      totalAmount: fields[8] as double,
      createdAt: fields[9] as DateTime,
      deliveryDeadline: fields[10] as DateTime?,
      status: fields[11] as String,
      acceptedAt: fields[12] as DateTime?,
      completedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.serviceId)
      ..writeByte(3)
      ..write(obj.professionalId)
      ..writeByte(4)
      ..write(obj.packageType)
      ..writeByte(5)
      ..write(obj.basePrice)
      ..writeByte(6)
      ..write(obj.addons)
      ..writeByte(7)
      ..write(obj.platformFeeAmount)
      ..writeByte(8)
      ..write(obj.totalAmount)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.deliveryDeadline)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.acceptedAt)
      ..writeByte(13)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderAddonAdapter extends TypeAdapter<OrderAddon> {
  @override
  final int typeId = 10;

  @override
  OrderAddon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderAddon(
      addonId: fields[0] as String,
      title: fields[1] as String,
      price: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderAddon obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.addonId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAddonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EscrowPaymentAdapter extends TypeAdapter<EscrowPayment> {
  @override
  final int typeId = 11;

  @override
  EscrowPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EscrowPayment(
      id: fields[0] as String,
      orderId: fields[1] as String,
      customerId: fields[2] as String,
      professionalId: fields[3] as String,
      amount: fields[4] as double,
      platformFeeAmount: fields[5] as double,
      professionalAmount: fields[6] as double,
      status: fields[7] as String,
      createdAt: fields[8] as DateTime,
      releasedAt: fields[9] as DateTime?,
      adminNotes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EscrowPayment obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.customerId)
      ..writeByte(3)
      ..write(obj.professionalId)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.platformFeeAmount)
      ..writeByte(6)
      ..write(obj.professionalAmount)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.releasedAt)
      ..writeByte(10)
      ..write(obj.adminNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EscrowPaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 12;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      amount: fields[3] as double,
      status: fields[4] as String,
      createdAt: fields[5] as DateTime,
      description: fields[6] as String?,
      relatedOrderId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.relatedOrderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WithdrawalRequestAdapter extends TypeAdapter<WithdrawalRequest> {
  @override
  final int typeId = 13;

  @override
  WithdrawalRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WithdrawalRequest(
      id: fields[0] as String,
      professionalId: fields[1] as String,
      amount: fields[2] as double,
      status: fields[3] as String,
      requestedAt: fields[4] as DateTime,
      approvedAt: fields[5] as DateTime?,
      completedAt: fields[6] as DateTime?,
      adminNotes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WithdrawalRequest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.professionalId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.requestedAt)
      ..writeByte(5)
      ..write(obj.approvedAt)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.adminNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithdrawalRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskSubmissionAdapter extends TypeAdapter<TaskSubmission> {
  @override
  final int typeId = 14;

  @override
  TaskSubmission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskSubmission(
      id: fields[0] as String,
      orderId: fields[1] as String,
      professionalId: fields[2] as String,
      description: fields[3] as String,
      attachmentUrls: (fields[4] as List).cast<String>(),
      submittedAt: fields[5] as DateTime,
      status: fields[6] as String,
      revisionNotes: fields[7] as String?,
      revisionNumber: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskSubmission obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.professionalId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.attachmentUrls)
      ..writeByte(5)
      ..write(obj.submittedAt)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.revisionNotes)
      ..writeByte(8)
      ..write(obj.revisionNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskSubmissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewAdapter extends TypeAdapter<Review> {
  @override
  final int typeId = 15;

  @override
  Review read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Review(
      id: fields[0] as String,
      orderId: fields[1] as String,
      reviewerId: fields[2] as String,
      revieweeId: fields[3] as String,
      rating: fields[4] as double,
      comment: fields[5] as String,
      createdAt: fields[6] as DateTime,
      reviewType: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Review obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.reviewerId)
      ..writeByte(3)
      ..write(obj.revieweeId)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.comment)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.reviewType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
