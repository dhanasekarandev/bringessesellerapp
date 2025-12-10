import 'package:bringessesellerapp/model/response/privacy_policy_res_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/privacy_policy_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/privacy_policy_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    _loadPrivacy();
  }

  void _loadPrivacy() {
    context.read<PrivacyPolicyCubit>().login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Privacy Policy",
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrivacy,
          )
        ],
      ),
      body: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
        builder: (context, state) {
          if (state.networkStatusEnum == NetworkStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.networkStatusEnum == NetworkStatusEnum.loaded) {
            TermsResponseModel model = state.termsResponseModel;

            if (model.result == null || model.result!.isEmpty) {
              return const Center(child: Text("No Data Found"));
            }

            final rawHtml = model.result!.first.description ?? "";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Html(
                data: rawHtml, // Directly render HTML
                // style: {
                //   "body": Style(
                //     fontSize: FontSize(15),
                //     lineHeight: LineHeight(1.5),
                //     //   color: Colors.black87,
                //   ),
                // },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
