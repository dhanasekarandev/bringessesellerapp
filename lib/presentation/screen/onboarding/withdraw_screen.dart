import 'package:bringessesellerapp/config/constant/api_constant.dart';
import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/model/response/account_detail_model.dart';
import 'package:bringessesellerapp/presentation/service/bank_service.dart';

import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawScreen extends StatefulWidget {
  final AccountDetailModel? accountDetailModel;
  const WithdrawScreen({super.key, this.accountDetailModel});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  String amount = "0";

  double availableBalance = 1215.00;

  List<String> keys = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    ".",
    "0",
    "⌫",
  ];

  /// FORMATTER — Indian format like 10,000 | 1,00,000
  String formatAmount(String value) {
    if (value.isEmpty || value == "0") return "0";

    bool hasDecimal = value.contains(".");
    String decimalPart = "";

    if (hasDecimal) {
      decimalPart = value.split(".")[1];
      value = value.split(".")[0];
    }

    String number = value.replaceAll(",", "");
    int len = number.length;

    if (len <= 3) {
      return hasDecimal ? "$number.$decimalPart" : number;
    }

    String lastThree = number.substring(len - 3);
    String remaining = number.substring(0, len - 3);

    remaining = remaining.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{2})+(?!\d))'), (Match m) => "${m[1]},");

    String formatted = "$remaining,$lastThree";

    return hasDecimal ? "$formatted.$decimalPart" : formatted;
  }

  /// KEYPAD HANDLER WITH 6 DIGIT LIMIT
  void onKeyTap(String key) {
    setState(() {
      String raw = amount.replaceAll(",", "");

      // Delete key
      if (key == "⌫") {
        if (raw.isNotEmpty && raw != "0") {
          raw = raw.substring(0, raw.length - 1);
          if (raw.isEmpty) raw = "0";
        }
      } else {
        // Block extra decimals
        if (key == "." && raw.contains(".")) return;

        // Prevent more than 6 digits before decimal
        String beforeDecimal = raw.contains(".") ? raw.split(".")[0] : raw;

        if (beforeDecimal.length >= 6 && key != ".") return;

        raw = raw == "0" ? (key == "." ? "0." : key) : raw + key;
      }

      amount = formatAmount(raw);
    });
  }

  bool isValidAmount() {
    double value = double.tryParse(amount.replaceAll(",", "")) ?? 0;
    return value >= 100 && value <= availableBalance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Withdraw"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Account selection UI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(child: Icon(Icons.account_balance, size: 18)),
                  SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${widget.accountDetailModel!.sellerDetails!.accountName}"),
                      SizedBox(height: 4),
                      Text(
                        "${BankHelper.getBankName(widget.accountDetailModel!.sellerDetails!.ifsc!)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.keyboard_arrow_down, size: 18),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Amount UI
            Text(
              "₹$amount",
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "₹$availableBalance available balance",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 30),

            // Keypad UI
            Expanded(
              child: GridView.builder(
                itemCount: keys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onKeyTap(keys[index]),
                    child: Center(
                      child: Text(
                        keys[index],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Continue Button
      bottomSheet: SafeArea(
        child: Opacity(
          opacity: isValidAmount() ? 1 : 0.4,
          child: IgnorePointer(
            ignoring: !isValidAmount(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.w),
              child: CustomButton(
                title: "Continue",
                onPressed: () {
                  double value = double.parse(amount.replaceAll(",", ""));

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      List<TextEditingController> otpControllers =
                          List.generate(4, (index) => TextEditingController());
                      List<FocusNode> focusNodes =
                          List.generate(4, (index) => FocusNode());

                      void submitOtp() {
                        String otp = otpControllers.map((c) => c.text).join();
                        if (otp.length == 4) {
                          print("OTP entered: $otp for ₹$value");
                          Navigator.pop(context); // Close bottom sheet
                        } else {
                          print("Enter complete 4-digit OTP");
                        }
                      }

                      return SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.4, // taller bottom sheet
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 20,
                              top: 20,
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Verify your  ₹${value.round()} withdrawl",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                vericalSpaceMedium,
                                Text(
                                  "Please verify the passcode that we sent to your mobile number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(4, (index) {
                                    return Material(
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: TextField(
                                          controller: otpControllers[index],
                                          focusNode: focusNodes[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          decoration: const InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty && index < 3) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      focusNodes[index + 1]);
                                            }
                                            if (value.isEmpty && index > 0) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      focusNodes[index - 1]);
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    onPressed: submitOtp,
                                    title: "Vetify & withdraw",
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
