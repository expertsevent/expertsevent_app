import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/layout/presentation/controller/bottom_nav_cubit.dart';
import 'package:expert_events/layout/presentation/screens/layout_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../core/cash_helper.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';

import '../../../controller/wallet/wallet_cubit.dart';

class HyperPayScreen extends StatefulWidget {
  final String packageId;
  final String amount;
  const HyperPayScreen(
      {Key? key, required this.packageId, required this.amount})
      : super(key: key);

  @override
  State<HyperPayScreen> createState() => _HyperPayScreenState();
}

class _HyperPayScreenState extends State<HyperPayScreen> {
  late final WebViewController controller;
  WebViewController? _webViewController;
  late final cubit = WalletCubit.get(context);
  late final bottomNavProvider = BottomNavCubit.get(context);

  @override
  void initState() {
    super.initState();
    getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppUI.mainColor,
          title: Text(
            "payment".tr(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: _webViewController == null
            ? const LoadingWidget()
            : WebViewWidget(
                controller: _webViewController!,
              ));
  }

  getUrl() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel("Channel", onMessageReceived: (message) {})
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith(
                'https://api.expertsevent.com/api/pay_status')) {
              String jwt = await CashHelper.getSavedString("jwt", "");
              http.Response response = await http.get(
                  Uri.parse(
                      "${request.url}&package_id=${widget.packageId}&amount=${widget.amount}"),
                  headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer $jwt"
                  });
              Map<String, dynamic> map = jsonDecode(response.body);
              if (map['status']) {
                if (mounted) {
                  AppUtil.removeUntilNavigator(context, const LayoutScreen());
                }
                bottomNavProvider.scale = 1.0;
                bottomNavProvider.tranX = 0;
                bottomNavProvider.tranY = 0;
                bottomNavProvider.menuOpen = false;
                if (mounted) {
                  AppUtil.successToast(context, map['message']);
                }
              } else {
                if (mounted) {
                  Navigator.pop(context);
                  AppUtil.errorToast(context, map['message']);
                }
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(cubit.walletView));
    setState(() {});
  }
}
