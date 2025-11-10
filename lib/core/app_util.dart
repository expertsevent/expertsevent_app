import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/core/ui/app_ui.dart';
import 'package:expert_events/core/ui/components.dart';
import 'package:expert_events/layout/presentation/screens/layout_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'cash_helper.dart';

class AppUtil {
  static double responsiveHeight(context) => MediaQuery.of(context).size.height;
  static double responsiveWidth(context) => MediaQuery.of(context).size.width;
  static mainNavigator(context, screen) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => screen));
  static removeUntilNavigator(context, screen) =>
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (route) => false);
  static replacementNavigator(context, screen) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => screen));

  static bool rtlDirection(context) {
    return EasyLocalization.of(context)!.currentLocale == const Locale('en')
        ? false
        : true;
  }

// Show dialog
  static dialog(context, title, List<Widget> dialogBody,
      {barrierDismissible = true, alignment, color}) async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AlertDialog(
            alignment: alignment ?? Alignment.center,
            backgroundColor: color ?? AppUI.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            title: CustomText(
              text: title,
              fontWeight: FontWeight.bold,
            ),
            insetPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.all(5),
            contentPadding: EdgeInsets.zero,
            content: Builder(builder: (context) {
              return SingleChildScrollView(
                child: ListBody(
                  children: dialogBody,
                ),
              );
            }),
          );
        });
  }

// Show dialog
  static dialog2(context, title, List<Widget> dialogBody,
      {barrierDismissible = true, backgroundColor}) async {
    return await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: CustomText(
              text: title,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: dialogBody,
              ),
            ),
          );
        });
  }

// Get current location
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getAddress(location) async {
    geocoding.Placemark placemark = await getPlaceMark(location);

    String place =
        (placemark.country!.isNotEmpty ? '${placemark.country!}, ' : '') +
            (placemark.administrativeArea!.isNotEmpty
                ? '${placemark.administrativeArea!}, '
                : '') +
            (placemark.subLocality!.isNotEmpty
                ? '${placemark.subLocality!}, '
                : '') +
            (placemark.street!.isNotEmpty ? '${placemark.street!} ' : '');

    place = place.isNotEmpty
        ? place.replaceFirst(', ', '', place.lastIndexOf(', '))
        : '';

    return place;
  }

  static Future<geocoding.Placemark> getPlaceMark(
    latLng,
  ) async {
    try {
      List<geocoding.Placemark> placeMarks = await geocoding
          .placemarkFromCoordinates(latLng.latitude, latLng.longitude,
              localeIdentifier: await CashHelper.getSavedString("lang", ""));

      geocoding.Placemark placemark = placeMarks[0];

      return placemark;
    } catch (e) {
      return Future.error(e);
    }
  }

  // toast msg
  static successToast(context, msg) {
    // ToastContext().init(context);
    // Toast.show(msg,duration: 3,gravity: 1,textStyle: TextStyle(color: AppUI.whiteColor),backgroundColor: AppUI.activeColor,);
    Flushbar(
      messageText: Row(
        children: [
          CustomText(
            text: msg,
            color: AppUI.whiteColor,
          ),
          const Spacer(),
          const Icon(
            Icons.check,
            color: AppUI.whiteColor,
          )
        ],
      ),
      messageColor: AppUI.whiteColor,
      messageSize: 18,
      // titleColor: AppUI.mainColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      // maxWidth: double.infinity,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: .1,
      backgroundColor: AppUI.mainColor,
      borderColor: AppUI.mainColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
    ).show(context);
  }

  static errorToast(context, msg) {
    // ToastContext().init(context);
    // Toast.show(msg,duration: 3,gravity: 1,textStyle: TextStyle(color: AppUI.whiteColor),backgroundColor: AppUI.errorColor);
    Flushbar(
      messageText: Row(
        children: [
          SizedBox(
              width: AppUtil.responsiveWidth(context) * 0.78,
              child: CustomText(
                text: msg,
                color: AppUI.whiteColor,
              )),
          const Spacer(),
          Icon(
            Icons.close,
            color: AppUI.whiteColor,
          )
        ],
      ),
      messageColor: AppUI.whiteColor,
      messageSize: 18,
      // titleColor: AppUI.mainColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      // maxWidth: double.infinity,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: .1,
      backgroundColor: AppUI.errorColor,
      borderColor: AppUI.errorColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
    ).show(context);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings? androidInitializationSettings;
  InitializationSettings? initializationSettings;

  Future<void> initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (Platform.isAndroid) {
      androidInitializationSettings =
          const AndroidInitializationSettings('@mipmap/ic_launcher');

      initializationSettings =
          InitializationSettings(android: androidInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings!);
    }
  }

  Future<void> showPushNotification(context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      AppUtil.mainNavigator(context, const LayoutScreen());
    });
    FirebaseMessaging.onMessage.listen((event) async {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails(
        'Channel ID',
        'Channel title',
        priority: Priority.high,
        importance: Importance.max,
        ticker: 'test',
        enableVibration: true,
        playSound: true,
      );
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, event.notification!.title,
          event.notification!.body, notificationDetails,
          payload: jsonEncode(event.data));
    });
  }

  static getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcm =  await FirebaseMessaging.instance.getToken();
    return fcm;
  }

  static filter(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: AppUI.whiteColor,
            ),
            height: AppUtil.responsiveHeight(context) * 0.75,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    CustomText(
                      text: "filter".tr(),
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppUI.blackColor,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      CustomText(
                        text: "location".tr(),
                        color: AppUI.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomInput(
                          controller: TextEditingController(),
                          fillColor: AppUI.inputColor,
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomText(
                        text: "eventType".tr(),
                        color: AppUI.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        height: AppUtil.responsiveHeight(context) * 0.3,
                        child: ResponsiveGridList(
                          shrinkWrap: true,
                          horizontalGridSpacing:
                              10, // Horizontal space between grid items
                          verticalGridSpacing:
                              10, // Vertical space between grid items
                          horizontalGridMargin:
                              10, // Horizontal space around the grid
                          verticalGridMargin:
                              10, // Vertical space around the grid
                          minItemWidth:
                              300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                          minItemsPerRow:
                              3, // The minimum items to show in a single row. Takes precedence over minItemWidth
                          maxItemsPerRow:
                              7, // The maximum items to show in a single row. Can be useful on large screens
                          listViewBuilderOptions:
                              ListViewBuilderOptions(), // Options that are getting passed to the ListView.builder() function
                          children: List.generate(7, (index) {
                            return const CustomCard(
                              elevation: 0,
                              radius: 20,
                              color: AppUI.inputColor,
                              child: CustomText(
                                text: "Wedding",
                                color: AppUI.bottomBarColor,
                                fontSize: 16,
                              ),
                            );
                          }), // The list of widgets in the list
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(text: "apply".tr()),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  Future<void> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
    } else {}
  }

  static Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
