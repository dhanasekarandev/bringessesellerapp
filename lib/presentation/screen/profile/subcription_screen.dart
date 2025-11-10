import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/subcription_checkout_req_model.dart';
import 'package:bringessesellerapp/model/response/subription_defaults_response_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/subscription_checkout_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubcriptionScreen extends StatefulWidget {
  final List<SubscriptionModel>? data;
  const SubcriptionScreen({super.key, required this.data});

  @override
  State<SubcriptionScreen> createState() => _SubcriptionScreenState();
}

class _SubcriptionScreenState extends State<SubcriptionScreen> {
  int selectedIndex = -1; // Track selected subscription
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
  }

  void _checkout({String? subsId, double? subsPrice}) {
    context.read<SubscriptionCheckoutCubit>().login(
        SubscriptionCheckoutReqModel(
            subscriptionId: subsId,
            subscriptionPrice: subsPrice,
            sellerId: sharedPreferenceHelper.getSellerId));
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions = widget.data ?? [];

    return BlocConsumer<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
      listener: (context, state) {
        if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
            state.editProfile.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Order Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: "Subscription"),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: subscriptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 4, // width / height ratio
              ),
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.purple
                            : Theme.of(context).cardColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).cardColor,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (sub.name ?? "").toUpperCase(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹ ${sub.price ?? 0}",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sub.duration ?? "",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
              child: CustomButton(
                title: "Save",
                onPressed: () {
                  if (selectedIndex != -1) {
                    final selectedSubscription = subscriptions[selectedIndex];
                    _checkout(
                        subsId: selectedSubscription.id,
                        subsPrice: double.parse(
                            selectedSubscription.price.toString()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a subscription")),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
