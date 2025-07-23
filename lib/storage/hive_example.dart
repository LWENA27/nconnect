import 'package:hive/hive.dart';
import '../models/user_adapter.dart';
import 'hive_boxes.dart';

Future<void> addUser(User user) async {
  var box = await Hive.openBox<User>(HiveBoxes.userBox);
  await box.put(user.uid, user);
}

Future<User?> getUser(String uid) async {
  var box = await Hive.openBox<User>(HiveBoxes.userBox);
  return box.get(uid);
}

Future<List<User>> getAllUsers() async {
  var box = await Hive.openBox<User>(HiveBoxes.userBox);
  return box.values.toList();
}

// Similar functions can be created for Service, Booking, Transaction, Review
