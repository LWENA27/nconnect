import 'package:hive/hive.dart';

part 'review.g.dart';

@HiveType(typeId: 4)
class Review {
  @HiveField(0)
  final String reviewId;
  @HiveField(1)
  final String bookingId;
  @HiveField(2)
  final int rating; // 1-5
  @HiveField(3)
  final String comment;
  @HiveField(4)
  final String? response; // Professional's response

  Review({
    required this.reviewId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    this.response,
  });
}
