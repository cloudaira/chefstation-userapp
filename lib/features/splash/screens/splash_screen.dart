import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:chefstation_multivendor/common/widgets/no_internet_screen_widget.dart';
import 'package:chefstation_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:chefstation_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:chefstation_multivendor/features/notification/domain/models/notification_body_model.dart';
import 'package:chefstation_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:chefstation_multivendor/features/splash/domain/models/deep_link_body.dart';
import 'package:chefstation_multivendor/helper/address_helper.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBodyModel? notificationBody;
  final DeepLinkBody? linkBody;
  const SplashScreen({super.key, required this.notificationBody, required this.linkBody});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);

      if(!firstTime) {
        ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(isConnected ? 'connected'.tr : 'no_connection'.tr, textAlign: TextAlign.center),
        ));
        if(isConnected) {
          _route();
        }else {
          Get.to(const NoInternetScreen());
        }
      }

      firstTime = false;

    });

    Get.find<SplashController>().initSharedData();
    if(AddressHelper.getAddressFromSharedPref() != null && (AddressHelper.getAddressFromSharedPref()!.zoneIds == null
        || AddressHelper.getAddressFromSharedPref()!.zoneData == null)) {
      AddressHelper.clearAddressFromSharedPref();
    }
    if(Get.find<AuthController>().isGuestLoggedIn() || Get.find<AuthController>().isLoggedIn()) {
      Get.find<CartController>().getCartDataOnline();
    }
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged?.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData(handleMaintenanceMode: false, notificationBody: widget.notificationBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return splashController.hasConnection
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/image/app_background_launcher.png',
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/image/ic_launcher.gif',
                      fit: BoxFit.contain,
                      width: 200, // Adjust as needed
                      height: 200, // Adjust as needed
                    ),
                  ),
                ],
              )
            : NoInternetScreen(child: SplashScreen(notificationBody: widget.notificationBody, linkBody: widget.linkBody));
      }),
    );
  }
}
