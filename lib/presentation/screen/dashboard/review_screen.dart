import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/review_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/review_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/review_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShopCustomerReviewsScreen extends StatefulWidget {
  const ShopCustomerReviewsScreen({super.key});

  @override
  State<ShopCustomerReviewsScreen> createState() =>
      _ShopCustomerReviewsScreenState();
}

class _ShopCustomerReviewsScreenState extends State<ShopCustomerReviewsScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    loadReview();
  }

  void loadReview() {
    final storeId = sharedPreferenceHelper.getStoreId;
    context.read<ReviewCubit>().login(
          ReviewReqModel(storeId: storeId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Customer Reviews"),
      body: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            final reviews = state.reviewResponseModel.result?.reviews ?? [];

            if (reviews.isEmpty) {
              return const Center(child: Text("No reviews available."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final item = reviews[index];
                return _ReviewCard(
                  name: item.userDetails?.name ?? "Anonymous",
                  rating: (item.rating ?? 0).toDouble(),
                  review: item.review ?? "",
                  time: item.createdAt ?? "",
                  // id: item.id ?? "",
                  avatarUrl: item.userDetails?.image ??
                      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
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
  // final String id;
  final String avatarUrl;

  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.review,
    required this.time,
    // required this.id,
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
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (_, __) =>
                          const Icon(Icons.star, color: Colors.orange),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(rating.toString(),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                // Text(
                //   "Review ID: $id • $time",
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                // ),
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
