import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CouponScreeen extends StatefulWidget {
  const CouponScreeen({super.key});

  @override
  State<CouponScreeen> createState() => _CouponScreeenState();
}

class _CouponScreeenState extends State<CouponScreeen> {
  final List<Map<String, String>> promos = [
    {
      'brand': 'Adidas',
      'logo': 'assets/adidas.png',
      'discount': '15% off',
      'condition': 'on purchase of \$199 or more',
      'expiry': 'till Nov 8',
    },
    {
      'brand': 'iHerb',
      'logo': 'assets/iherb.png',
      'discount': '20% off',
      'condition': 'on purchase of \$59 or more',
      'expiry': 'till Oct 11',
    },
    {
      'brand': 'McDonald\'s',
      'logo': 'assets/mcdonalds.png',
      'discount': '15% off',
      'condition': 'Big Tasty',
      'expiry': 'till Oct 29',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Coupon List"),
      body: ListView.builder(
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final promo = promos[index];
          return CustomCard(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(5),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppTheme.primaryColor.withOpacity(0.2)),
                child: Image.asset(
                  'assets/icons/coupon.png',
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              title: Text(promo['discount']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(promo['condition']!),
                  Text(promo['expiry']!,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          context.go('/profile/coupon/add');
        },
      ),
    );
  }
}
