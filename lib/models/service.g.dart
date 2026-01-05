// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 1;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      id: fields[0] as String,
      providerId: fields[1] as String,
      categoryId: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      deliveryTimeDays: fields[5] as int,
      maxRevisions: fields[6] as int,
      status: fields[7] as String,
      ratingAvg: fields[8] as double,
      totalOrders: fields[9] as int,
      packages: (fields[10] as List).cast<ServicePackage>(),
      addons: (fields[11] as List).cast<ServiceAddon>(),
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.providerId)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.deliveryTimeDays)
      ..writeByte(6)
      ..write(obj.maxRevisions)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.ratingAvg)
      ..writeByte(9)
      ..write(obj.totalOrders)
      ..writeByte(10)
      ..write(obj.packages)
      ..writeByte(11)
      ..write(obj.addons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServicePackageAdapter extends TypeAdapter<ServicePackage> {
  @override
  final int typeId = 6;

  @override
  ServicePackage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServicePackage(
      id: fields[0] as String,
      serviceId: fields[1] as String,
      packageType: fields[2] as String,
      price: fields[3] as double,
      description: fields[4] as String,
      features: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ServicePackage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceId)
      ..writeByte(2)
      ..write(obj.packageType)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.features);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicePackageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceAddonAdapter extends TypeAdapter<ServiceAddon> {
  @override
  final int typeId = 7;

  @override
  ServiceAddon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceAddon(
      id: fields[0] as String,
      serviceId: fields[1] as String,
      title: fields[2] as String,
      price: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceAddon obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAddonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 8;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      iconUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
