import 'package:hive/hive.dart';
import 'professional_service.dart';

class ProfessionalServiceAdapter extends TypeAdapter<ProfessionalService> {
  @override
  final int typeId = 9;

  @override
  ProfessionalService read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfessionalService(
      id: fields[0] as String,
      providerId: fields[1] as String,
      categoryId: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      deliveryTimeDays: fields[5] as int,
      maxRevisions: fields[6] as int,
      status: fields[7] as String? ?? 'active',
      ratingAvg: fields[8] as double? ?? 0.0,
      totalOrders: fields[9] as int? ?? 0,
      packages: (fields[10] as List?)?.cast<ProfessionalServicePackage>() ?? [],
      addons: (fields[11] as List?)?.cast<ProfessionalServiceAddon>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, ProfessionalService obj) {
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
      other is ProfessionalServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfessionalServicePackageAdapter
    extends TypeAdapter<ProfessionalServicePackage> {
  @override
  final int typeId = 10;

  @override
  ProfessionalServicePackage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfessionalServicePackage(
      id: fields[0] as String,
      serviceId: fields[1] as String,
      packageType: fields[2] as String,
      price: fields[3] as double,
      description: fields[4] as String,
      features: (fields[5] as List?)?.cast<String>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, ProfessionalServicePackage obj) {
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
      other is ProfessionalServicePackageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfessionalServiceAddonAdapter
    extends TypeAdapter<ProfessionalServiceAddon> {
  @override
  final int typeId = 11;

  @override
  ProfessionalServiceAddon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfessionalServiceAddon(
      id: fields[0] as String,
      serviceId: fields[1] as String,
      title: fields[2] as String,
      price: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProfessionalServiceAddon obj) {
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
      other is ProfessionalServiceAddonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
