import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';

class AppModel {
  final String icon;
  final String name;
  final String subtitle;
  final double rating;
  final String applink;

  AppModel({
    required this.icon,
    required this.applink,
    required this.name,
    required this.subtitle,
    required this.rating,
  });
}

List<AppModel> appList = [
  AppModel(
      icon: "assets/images/applogo.jpg",
      name: "Bringesse Seller App",
      subtitle: "Bringesse",
      rating: 4.0,
      applink:
          'https://play.google.com/store/apps/details?id=com.app.bringessesellerapp'),
  AppModel(
      icon: "assets/icons/B Logo 512 X 512.png",
      name: "Bringesse",
      subtitle: "Bringesse • Ecommerce",
      rating: 4.3,
      applink:
          'https://play.google.com/store/apps/details?id=com.app.bringessedeliveryuserapp'),
  AppModel(
      icon: "assets/icons/photo_2025-09-29_18-03-11.png",
      name: "Bringesse Delivery Partner",
      subtitle: "Delivery • Restaurant • Casual",
      rating: 4.1,
      applink:
          'https://play.google.com/store/apps/details?id=com.app.bringessedeliverypartner'),
];

class PlayStoreListScreen extends StatelessWidget {
  const PlayStoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Quick App Links"),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: appList.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          return AppTile(app: appList[index]);
        },
      ),
    );
  }
}

class AppTile extends StatefulWidget {
  final AppModel app;

  const AppTile({super.key, required this.app});

  @override
  State<AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<AppTile> {

  String? packageName;

  @override
  void initState() {
    super.initState();
  
  }

  
 

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            widget.app.icon,
            height: 72.h,
            width: 72.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 12.w),

        /// Text section
        Expanded(
          child: InkWell(
            onTap: () => launchUrl(Uri.parse(widget.app.applink)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.app.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.app.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    const Icon(Icons.star, size: 15, color: Colors.orange),
                    Text(
                      " ${widget.app.rating}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

       
        
      ],
    );
  }
}
