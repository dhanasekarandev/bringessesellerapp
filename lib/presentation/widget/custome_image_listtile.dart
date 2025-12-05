import 'package:flutter/material.dart';

class CustomImageListTile extends StatelessWidget {
  final String imageUrl;
  final String? offer;
  final String? offerPrice;
  final String title;
  final String price;
  final String? quantity;
  final String status;

  const CustomImageListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.status,
    this.quantity,
    this.offerPrice,
    this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final hasOffer = offer?.toLowerCase() == "true";
    print("sldhfbs${offer}");
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, size: 40),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRICE ROW
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Price: ",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (hasOffer)
                    TextSpan(
                      text: "₹ $price  ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  TextSpan(
                    text: hasOffer ? "₹ ${offerPrice ?? price}" : "₹ $price",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            // QUANTITY ROW
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Quantity: ",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  TextSpan(
                    text: "${quantity}" ?? "-",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      trailing: status.isEmpty
          ? const Icon(Icons.arrow_forward_ios_outlined, size: 18)
          : Text(
              status,
              style: TextStyle(
                color: status == "Stock available"
                    ? Colors.green
                    : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
