import 'dart:io';

import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/model/response/oder_list_response.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class SuccessOrderDetailsScreen extends StatefulWidget {
  final OrderDetails? order;
  const SuccessOrderDetailsScreen({super.key, required this.order});

  @override
  State<SuccessOrderDetailsScreen> createState() =>
      _SuccessOrderDetailsScreenState();
}

class _SuccessOrderDetailsScreenState extends State<SuccessOrderDetailsScreen> {
  Future<void> downloadInvoice(String orderId) async {
    try {
      final url =
          "https://bringesse.com:3002/order/download/${widget.order!.orderId}";

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final dir = await getTemporaryDirectory();
        final filePath = "${dir.path}/invoice_$orderId.pdf";
        final file = File(filePath);

        await file.writeAsBytes(bytes);

        print("Invoice saved at $filePath");

        await OpenFilex.open(filePath); // Opens PDF
      } else {
        print("Download failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading invoice: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'OrderDetails'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Info section
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    (widget.order!.orderItems != null &&
                            widget.order!.orderItems!.isNotEmpty)
                        ? "${ApiConstant.imageUrl}/public/media/items/${widget.order!.orderItems!.first.imageUrl}"
                        : "https://static.vecteezy.com/system/resources/previews/024/212/031/non_2x/cardboard-box-with-check-mark-confirmed-order-delivery-concept-return-parcel-to-courier-shipment-checklist-cartoon-free-png.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 60,
                        width: 60,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.order!.uniqueId}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.order!.orderItems != null &&
                          widget.order!.orderItems!.isNotEmpty)
                        Text(
                          widget.order!.orderItems!.first.name ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Order ID copy row
            Row(
              children: [
                Text(
                  "Order ${widget.order!.orderId}",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                SizedBox(width: 6),
                Icon(Icons.copy, size: 16, color: Colors.blueGrey),
              ],
            ),

            const SizedBox(height: 16),

            /// Delivery Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivered, ${DateFormat('dd MMM ').format(DateTime.parse(widget.order!.updatedAt.toString()))}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("Your item has been delivered"),

                  const SizedBox(height: 20),

                  /// timeline
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Container(height: 2, color: Colors.green)),
                      const SizedBox(width: 6),
                      Column(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Order Confirmed",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 2),
                            Text(
                                "${DateFormat('MMM dd ').format(DateTime.parse(widget.order!.createdAt.toString()))}",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Delivered",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 2),
                            Text(
                                "${DateFormat('MMM dd ').format(DateTime.parse(widget.order!.updatedAt.toString()))}",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // const Center(
                  //   child: Text(
                  //     "See all updates",
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ Delivery Details
            Text(
              "Delivery details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${widget.order!.deliveryAddress!.address},${widget.order!.deliveryAddress!.location}",
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                          "${widget.order!.userDetails!.name},${widget.order!.userDetails!.contactNo}"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ Price details
            Text(
              "Price details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _priceRow("Listing price", "${widget.order!.total}"),
                  _priceRow("Special price", "${widget.order!.adminOffer}"),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Total fees"),
                          Icon(Icons.arrow_drop_down, size: 18)
                        ],
                      ),
                      Text("${widget.order!.total}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total amount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${widget.order!.total}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // SizedBox(height: 16),
                  // Row(
                  //   children: const [
                  //     Icon(Icons.currency_rupee, size: 18),
                  //     SizedBox(width: 6),
                  //     Text("Cash On Delivery"),
                  //   ],
                  // ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      downloadInvoice(widget.order!.orderId.toString());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Text("Download Invoice"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            /// Offers earned
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.grey.shade300),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: const [
            //       Text("Offers earned"),
            //       Icon(Icons.keyboard_arrow_down),
            //     ],
            //   ),
            // ),

            SizedBox(height: 20),

            /// Order ID footer
            Row(
              children: const [
                Text("Order ID", style: TextStyle(color: Colors.grey)),
              ],
            ),

            SizedBox(height: 8),

            Row(
              children: const [
                Text("OD434726887547772100",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 6),
                Icon(Icons.copy, size: 16),
              ],
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Helper method
  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}
