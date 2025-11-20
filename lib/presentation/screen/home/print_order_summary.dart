import 'package:bringessesellerapp/model/response/oder_list_response.dart';
import 'package:flutter/material.dart';

class PrintableInvoiceScreen extends StatelessWidget {
  final OrderDetails order; // replace with your actual model

  const PrintableInvoiceScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printable Invoice"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: implement print() or PDF download
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Divider(),
                summaryRow("Item(s) Subtotal:", "₹${order.total}"),
                summaryRow("Shipping:", "₹${order.deliveryCharge}"),
                summaryRow("Marketplace Fee:", "₹${order.price}"),
                summaryRow("Total:", "₹${order.total}"),
                summaryRow("Promotion Applied:", "-₹${order.deliveryAddress}"),
                const Divider(height: 30),
                summaryRow("Grand Total:", "₹${order.total}", bold: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// row widget just like amazon invoice
  Widget summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
