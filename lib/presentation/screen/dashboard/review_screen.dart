import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // ✅ add this import

class ShopCustomerReviewsScreen extends StatelessWidget {
  const ShopCustomerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        "name": "John Doe",
        "rating": 4.5,
        "review": "Great experience and fast delivery!",
        "time": "1 min ago",
        "id": "R-987654",
        "avatar": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
      },
      {
        "name": "Sarah Smith",
        "rating": 5.0,
        "review": "Excellent service and friendly staff.",
        "time": "3 mins ago",
        "id": "R-987321",
        "avatar": "https://cdn-icons-png.flaticon.com/512/2922/2922510.png",
      },
      {
        "name": "Alex Johnson",
        "rating": 3.5,
        "review": "Good but room for improvement.",
        "time": "10 mins ago",
        "id": "R-986210",
        "avatar": "https://cdn-icons-png.flaticon.com/512/4128/4128349.png",
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(title: " Reviews"),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final item = reviews[index];
          return _ReviewCard(
            name: item['name'].toString(),
            rating: double.parse(item['rating'].toString()),
            review: item['review'].toString(),
            time: item['time'].toString(),
            id: item['id'].toString(),
            avatarUrl: item['avatar'].toString(),
          );
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String review;
  final String time;
  final String id;
  final String avatarUrl;

  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.review,
    required this.time,
    required this.id,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).focusColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              avatarUrl,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, size: 50, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Text(
                      "U/A",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      "Customer Rating: ",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.orange),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Review ID: $id   •   $time",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  review,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
