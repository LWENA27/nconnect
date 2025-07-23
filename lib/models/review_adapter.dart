import 'package:hive/hive.dart';

part 'review_adapter.g.dart';

@HiveType(typeId: 4)
class Review extends HiveObject {
  @HiveField(0)
  String reviewId;
  @HiveField(1)
  String bookingId;
  @HiveField(2)
  int rating;
  @HiveField(3)
  String comment;
  @HiveField(4)
  String? response;

  Review({
    required this.reviewId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    this.response,
  });
}
