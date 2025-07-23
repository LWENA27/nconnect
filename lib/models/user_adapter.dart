import 'package:hive/hive.dart';

part 'user_adapter.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String role;
  @HiveField(2)
  String name;
  @HiveField(3)
  String email;
  @HiveField(4)
  String phone;
  @HiveField(5)
  bool verified;

  User({
    required this.uid,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    required this.verified,
  });
}
