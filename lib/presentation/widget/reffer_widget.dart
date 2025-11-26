import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class DriverRefferal extends StatefulWidget {
  final String? storeId;
  const DriverRefferal({super.key, this.storeId});

  @override
  State<DriverRefferal> createState() => _DriverRefferalState();
}

class _DriverRefferalState extends State<DriverRefferal> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // 🔥 Premium Gradient Header
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFff5f6d), Color(0xFFffc371)], // Zomato style
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.white, size: 26),
                ),
                SizedBox(height: 20),
                Text(
                  "Refer & Earn ₹100",
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Invite friends & earn extra rewards instantly!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 🧊 Glass Card – Premium Feel
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            "https://static.vecteezy.com/system/resources/thumbnails/024/667/393/small/download-concept-install-symbol-tiny-people-downloading-data-files-on-smartphone-app-load-symbol-modern-flat-cartoon-style-illustration-on-white-background-vector.jpg",
                            height: 190,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Referral Steps
                        Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Download and activate your Bringesse Partner account",
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.group_add, color: Colors.orange),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Invite friends using your referral link",
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(Icons.currency_rupee, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Earn ₹100 when 4 friends register",
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Terms and Conditions Card

                  const SizedBox(height: 20),

                  // checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isAccepted,
                        onChanged: (v) => setState(() => isAccepted = v!),
                      ),
                      const Expanded(
                        child: Text(
                          "I agree to the referral terms and understand rewards depend on successful registration.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Link Box
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 14, vertical: 14),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(14),
                  //     border: Border.all(color: Colors.grey.shade300),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           referralLink,
                  //           style: const TextStyle(fontSize: 14),
                  //         ),
                  //       ),
                  //       InkWell(
                  //         onTap: () => Share.share(referralLink),
                  //         child: Container(
                  //           padding: const EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //             color: Colors.black,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: const Icon(Icons.share,
                  //               color: Colors.white, size: 20),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isAccepted
                          ? () => Share.share(
                              'https://www.bringesse.com/web/app-invite-friends${widget.storeId}')
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAccepted
                            ? const Color(0xFFff5f6d)
                            : Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Share App Link",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
