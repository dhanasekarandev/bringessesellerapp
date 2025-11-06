import 'package:flutter/material.dart';

class CustomImageListTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? subtitle1;
  final String status;

  const CustomImageListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.status,
    this.subtitle1,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            subtitle1 ?? "",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      trailing: status == ''
          ? Icon(Icons.arrow_forward_ios_outlined)
          : Text(
              status,
              style: TextStyle(
                color: status.toLowerCase() == "approved"
                    ? Colors.green
                    : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
