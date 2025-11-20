import 'package:bringessesellerapp/model/response/privacy_policy_res_model.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/privacy_policy_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/profile/bloc/privacy_policy_state.dart';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart' as html_parser;

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

  // Helper function to decode escaped unicode HTML
  String decodeUnicodeHtml(String data) {
    return data
        .replaceAll(r'\u003C', '<')
        .replaceAll(r'\u003E', '>')
        .replaceAll(r'\u0026', '&');
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

            // Get the HTML text from API
            final rawHtml = model.result!.first.description ?? "";

            // STEP 1: Decode unicode escaped HTML
            final decodedHtml = decodeUnicodeHtml(rawHtml);

            // STEP 2: Remove HTML tags -> convert to plain text
            final document = html_parser.parse(decodedHtml);
            final String cleanText = document.body?.text ?? "";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                cleanText,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
