import 'dart:io';
import 'package:bringessesellerapp/config/constant/contsant.dart';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:bringessesellerapp/model/request/promotion_checkout_req_model.dart';
import 'package:bringessesellerapp/model/request/promotion_req_model.dart';
import 'package:bringessesellerapp/model/request/transaction_request_model.dart';
import 'package:bringessesellerapp/model/response/promotion_predata_response_model.dart';
import 'package:bringessesellerapp/presentation/repository/razorpay_repo.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_checkout_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_checkout_state.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_create_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_create_state.dart';
import 'package:bringessesellerapp/presentation/screen/banner/bloc/promotion_transction_cubit.dart';
import 'package:bringessesellerapp/presentation/widget/custom_card.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:bringessesellerapp/presentation/widget/custome_textfeild.dart';
import 'package:bringessesellerapp/presentation/widget/dotted_container.dart';
import 'package:bringessesellerapp/presentation/widget/sub_title.dart';
import 'package:bringessesellerapp/presentation/widget/title_text.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:bringessesellerapp/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddBannerScreen extends StatefulWidget {
  final List<Section>? sections;
  final String? currency;
  final String? storeId;
  final AppData? appData;
  const AddBannerScreen(
      {super.key, this.sections, this.currency, this.storeId, this.appData});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  bool footerChecked = false;
  bool headerChecked = false;
  bool categoryChecked = false;
  bool searchChecked = false;
  String? selectedOption;
  final List<String> options = [
    'Store',
    'Link',
    'Category',
  ];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    super.initState();
  }

  Future<void> _selectDate(TextEditingController controller,
      {TextEditingController? startController}) async {
    DateTime initialDate = DateTime.now();

    DateTime firstDate =
        startController != null && startController.text.isNotEmpty
            ? DateFormat('dd-MMM-yyyy').parse(startController.text)
            : initialDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Format as 12/Feb/2025
      String formattedDate = DateFormat('dd-MMM-yyyy').format(picked);
      controller.text = formattedDate;
    }
  }

  void _save() {
    final sectionIds = selectedSections
        .where((e) => e.id != null && e.id!.isNotEmpty)
        .map((e) => e.id!)
        .toList();

    final sectionTypes = selectedSections
        .where((e) => e.type != null && e.type!.isNotEmpty)
        .map((e) => e.type!)
        .toList();

    context.read<PromotionCreateCubit>().login(PromotionRequestModel(
          endDate: _endDateController.text.trim(),
          sectionId: sectionIds,
          sections: sectionTypes,
          type: selectedOption,
          startDate: _startDateController.text.trim(),
          storeId: widget.storeId,
          appImage: _bannerImage,
        ));
  }

  File? _bannerImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickBannerImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final int fileSize = await file.length();

    if (fileSize > 5 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File size exceeds 5 MB')),
      );
      return;
    }

    final decoded = await decodeImageFromList(file.readAsBytesSync());

    if (decoded.width < 1029 || decoded.height < 474) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image must be at least 1029×474')),
      );
      return;
    }

    setState(() {
      _bannerImage = file;
    });
  }

  double calculateTotalPrice() {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      return 0;
    }

    DateTime startDate =
        DateTime.tryParse(_startDateController.text) ?? DateTime.now();
    DateTime endDate =
        DateTime.tryParse(_endDateController.text) ?? DateTime.now();

    int numberOfDays = endDate.difference(startDate).inDays + 1;

    if (numberOfDays <= 0) return 0;

    return numberOfDays * double.parse(selectedPrice.toString());
  }

  double? totalAmount;
  String? promotionId;
  double? selectedPrice;
  final List<Section> selectedSections = [];
  final List<String> selectedNames = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<PromotionCheckoutCubit, PromotionCheckoutState>(
        listener: (context, checkoutState) {
          if (checkoutState.networkStatusEnum == NetworkStatusEnum.loaded &&
              checkoutState.promotionResponseModel.statuscode == 200) {
            final orderId = checkoutState.promotionResponseModel.orderId ?? "";
            double totalAmount = calculateTotalPrice();
            int amountInPaise = (totalAmount * 100).toInt();

            final paymentRepo = PaymentRepository();
            paymentRepo.init(
              onSuccess: (response) {
                showAppToast(message: 'Payment successful');
                context.read<PromotionTransctionCubit>().login(
                      TransactionRequestModel(
                        orderId: response.orderId,
                        paymentId: response.paymentId,
                        signature: response.signature,
                        promotionId: promotionId,
                      ),
                    );
              },
              onError: (response) {
                showAppToast(message: 'Payment failed ${response.message}');
              },
              onExternalWallet: (response) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //       content: Text("External wallet: ${response.walletName}")),
                // );
              },
            );

            // ✅ Open Razorpay checkout
            paymentRepo.openCheckout(
              key: widget.appData!.razorKey ?? "",
              amount: amountInPaise,
              name: "Bringesse Promotions",
              description: "Promotion Payment",
              orderId: orderId, // Required for signature
              email: "seller@example.com",
            );
          }
        },
        child: BlocConsumer<PromotionCreateCubit, PromotionCreateState>(
          listener: (context, state) {
            if (state.networkStatusEnum == NetworkStatusEnum.loaded &&
                state.promotionResponseModel.status == "true") {
              setState(() {
                promotionId = state.promotionResponseModel.promotionId;
              });
              // sharedPreferenceHelper
              //     .savePromotionId(state.promotionResponseModel.promotionId);

              /// ✅ Trigger Checkout API
              context.read<PromotionCheckoutCubit>().login(
                    PromotionCheckoutReqModel(
                      bannerPrice: selectedPrice.toString(),
                      promotionId: state.promotionResponseModel.promotionId,
                    ),
                  );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: const CustomAppBar(title: "Add Banner"),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleText(
                                title: "Create banner display place"),
                            vericalSpaceMedium,
                            Container(
                              height: 300.h,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.sections!.length,
                                itemBuilder: (context, index) {
                                  final item = widget.sections![index];
                                  final isSelected = selectedSections
                                      .any((element) => element.id == item.id);
                                  selectedPrice = selectedSections.fold<double>(
                                      0,
                                      (sum, section) =>
                                          sum +
                                          (double.parse(
                                              section.price.toString())));
                                  return customListTile(
                                    title: item.type ?? 'No Name',
                                    trailing1:
                                        "${widget.currency}${item.price?.toString()}",
                                    trailing2: 'Day',
                                    value: isSelected,
                                    onChanged: (checked) {
                                      setState(() {
                                        if (checked == true) {
                                          selectedSections.add(item);
                                          selectedNames.add(item.type ?? "");
                                        } else {
                                          selectedSections.removeWhere(
                                              (element) =>
                                                  element.id == item.id);
                                          selectedNames.remove(item.type);
                                        }

                                        selectedPrice =
                                            selectedSections.fold<double>(
                                          0,
                                          (sum, section) =>
                                              sum +
                                              (double.tryParse(section.price
                                                      .toString()) ??
                                                  0),
                                        );
                                      });
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomCard(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleText(title: "Upload banner image"),
                          const SubTitleText(title: "Upload banner image"),
                          vericalSpaceMedium,
                          InkWell(
                            onTap: _pickBannerImage,
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: DottedContainer(
                                child: _bannerImage == null
                                    ? const Text("Upload Image")
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: Image.file(
                                          _bannerImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SubTitleText(
                              title:
                                  "Minimum dimension is 1029x474 and maximum file size is : 5MB"),
                        ],
                      )),
                      CustomCard(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SubTitleText(title: "Promotion"),
                          vericalSpaceMedium,
                          DropdownButtonFormField<String>(
                            value: selectedOption,
                            hint: const Text("Select option"),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            items: options.map((option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                          ),
                          if (selectedOption == 'Link') ...[
                            SizedBox(height: 16.h),
                            const SubTitleText(title: "URL"),
                            CustomTextField(
                              hintText: "Enter URL",
                              controller: _url,
                            ),
                          ]
                        ],
                      )),
                      CustomCard(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleText(title: "Select banner date"),
                          vericalSpaceMedium,
                          TextFormField(
                            controller: _startDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Start Date",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDate(_startDateController),
                          ),
                          vericalSpaceMedium,
                          TextFormField(
                            controller: _endDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "End Date",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDate(_endDateController,
                                startController: _startDateController),
                          ),
                          vericalSpaceSmall,
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
                  child: CustomButton(
                    title: calculateTotalPrice() > 0
                        ? "Pay ₹${calculateTotalPrice().round()}"
                        : "Pay",
                    onPressed: () {
                      var totalAmount = calculateTotalPrice();
                      if (totalAmount <= 0) {
                        Fluttertoast.showToast(
                            msg: "Please select valid start and end date");
                        return;
                      }
                      _save();
                    },
                    icon: Icons.arrow_forward_ios_rounded,
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget customListTile({
    required String title,
    required String trailing1,
    required String trailing2,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      height: 60.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: value
            ? AppTheme.primaryColor.withOpacity(0.15)
            : AppTheme.graycolor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: value ? AppTheme.primaryColor : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailing1,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                trailing2,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
