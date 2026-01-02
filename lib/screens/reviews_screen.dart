import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/review_adapter.dart';
import '../storage/hive_boxes.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    var box = await Hive.openBox<Review>(HiveBoxes.reviewBox);
    setState(() {
      reviews = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews & Feedback'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  final ratingController = TextEditingController();
                  final commentController = TextEditingController();
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Submit Review'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: ratingController,
                            decoration: InputDecoration(
                              labelText: 'Rating (1-5)',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: commentController,
                            decoration: InputDecoration(labelText: 'Comment'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final review = Review(
                              reviewId: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              bookingId: 'demo_booking',
                              rating: int.tryParse(ratingController.text) ?? 5,
                              comment: commentController.text,
                              response: null,
                            );
                            var box = await Hive.openBox<Review>(
                              HiveBoxes.reviewBox,
                            );
                            await box.put(review.reviewId, review);
                            Navigator.pop(context);
                            setState(() => reviews.add(review));
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.add_comment),
                label: Text('Add Review'),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(12),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.star, color: Colors.amber),
                      title: Text(
                        'Rating: ${review.rating}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(review.comment),
                      trailing: review.response != null
                          ? Text('Response: ${review.response}')
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
