import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/model/request/notification_req_model.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/notification_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/home/bloc/notification_state.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotficationScreen extends StatefulWidget {
  const NotficationScreen({super.key});

  @override
  State<NotficationScreen> createState() => _NotficationScreenState();
}

class _NotficationScreenState extends State<NotficationScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();

    context.read<NotificationCubit>().login(NotificationReqModel(
          sellerId: sharedPreferenceHelper.getSellerId,
          offset: '',
          pageId: '',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Notification",
        showLeading: false,
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            final data = state.notificationResponseModel.result;
            if (state.notificationResponseModel.status == 'true' ||
                state.notificationResponseModel.status == true) {
              showAppToast(
                message: "Notification List loaded successfully",
              );
            } else {
              Fluttertoast.showToast(
                msg: "Something went wrong",
                backgroundColor: Colors.red,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            }
          } else if (state.networkStatusEnum == NetworkStatusEnum.failed) {
            // Fluttertoast.showToast(
            //   msg: "Network error",
            //   backgroundColor: Colors.red,
            //   textColor: Colors.white,
            //   toastLength: Toast.LENGTH_SHORT,
            // );
          }
        },
        builder: (context, state) {
          // Loading state
          // if (state.networkStatusEnum == NetworkStatusEnum.loading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          // Check if result is empty
          if (state.notificationResponseModel.result == null ||
              state.notificationResponseModel.result!.isEmpty) {
            return const Center(
              child: Text(
                "No notifications found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Display notification list
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.notificationResponseModel.result!.length,
            itemBuilder: (context, index) {
              final notification =
                  state.notificationResponseModel.result![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomCard(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      notification.type ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      notification.message ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      // Show dialog on tap
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(notification.type ?? "Notification"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.message ?? "",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Received: ${notification.createdAt ?? ''}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
