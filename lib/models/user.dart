import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String role; // admin, provider, customer
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String phone;
  @HiveField(5)
  final bool verified;

  User({
    required this.uid,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    required this.verified,
  });
}
