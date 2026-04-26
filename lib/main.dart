import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expert_events/invitations/presentation/controller/invitations_cubit.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:expert_events/more/presentation/controller/wallet/wallet_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_event/presentation/controller/add_event_cubit.dart';
import 'auth/presentation/controller/auth/auth_cubit.dart';
import 'auth/presentation/controller/forget_pass/forget_pass_cubit.dart';
import 'core/app_util.dart';
import 'core/guest_mode.dart';
import 'core/network_connection.dart';
import 'core/ui/app_ui.dart';
import 'event/presentation/controller/events/events_cubit.dart';
import 'event/presentation/controller/guards/guards_cubit.dart';
import 'home/presentation/controller/home_cubit.dart';
import 'intro/presentation/controller/intro_cubit.dart';
import 'intro/presentation/screens/splash_screen.dart';
import 'layout/presentation/controller/bottom_nav_cubit.dart';
import 'core/cash_helper.dart';
import 'package:timezone/data/latest.dart' as tzdata;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // use Brightness.dark if color is light
      statusBarBrightness: Brightness.light,
    ),
  );

  // Things we *must* await before runApp:
  //   - Firebase: many plugins assume the default app is initialized.
  //   - EasyLocalization: needed so MaterialApp can resolve locales.
  // Run them in parallel to cut cold-start time roughly in half.
  await Future.wait<void>([
    Firebase.initializeApp(),
    EasyLocalization.ensureInitialized(),
  ]);

  // Cheap, synchronous setup.
  tzdata.initializeTimeZones();
  NetworkInfo.initialize();

  // Hydrate the guest-mode flag from SharedPreferences before any cubits
  // fire (several start in MyApp.build). They check `GuestMode.isGuest`
  // synchronously to skip authenticated network calls.
  await GuestMode.load();

  // Notification setup talks to Firebase Messaging + flutter_local_notifications
  // and previously blocked the first frame. It does not need to complete
  // before the splash is visible, so kick it off in the background.
  unawaited(AppUtil().initNotification());

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'lang',
        fallbackLocale: const Locale('ar'),
       // startLocale: const Locale('ar'),
        child: const  MyApp()),
  );

  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   NetworkInfo.stream.listen((connected) {
  //     if (connected) {
  //       print("✅ Internet available");
  //     } else {
  //       print("🚫 No internet connection");
  //     }
  //     //}
  //   });
  // });
}

Future<void> storeDeviceLanguageIfNotChosen(BuildContext context) async {
  // Check if user has already selected a language before
  final hasChosenLanguage = await CashHelper.getSavedString("lang", "") != "" ? true : false;

  if (!hasChosenLanguage) {
    // Get the device-detected language from easy_localization
    final deviceLang = context.locale.languageCode;
    await CashHelper.setSavedString('lang', deviceLang);

    print("Stored default device language: $deviceLang");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppsflyerSdk _appsflyerSdk;
  late FacebookAppEvents facebookAppEvents;
  bool _languageStored = false;

  @override
  void initState() {
    super.initState();
    // Defer all third-party analytics SDK initialization until after the
    // first frame is on screen. None of these are required for the splash
    // to render, and several of them perform synchronous platform-channel
    // work that delays first paint when started from initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_initAppsFlyer());
      unawaited(_initFacebookAppEvents());
      _ensureDeviceLanguageStored();
    });
  }

  Future<void> _ensureDeviceLanguageStored() async {
    if (_languageStored) return;
    _languageStored = true;
    try {
      await storeDeviceLanguageIfNotChosen(context);
    } catch (e) {
      debugPrint('storeDeviceLanguageIfNotChosen error: $e');
    }
  }

  Future<void> _initAppsFlyer() async {
    // Configure AppsFlyer
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "HD7GQojLRGobHMFApdaSGZ",
        appId: Platform.isAndroid ? "com.expert_events.expert_events" : "1661312796", // Empty for Android, iOS App Store ID for iOS
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15,
        disableAdvertisingIdentifier: false,
        disableCollectASA: false,
        manualStart: false);
    _appsflyerSdk = AppsflyerSdk(options);

    // Set customer user ID if available (helps with tracking)
    // _appsflyerSdk.setCustomerUserId("user_id_here");

    print("AppsFlyer: Initializing SDK...");

    // Register callbacks BEFORE initSdk
    _appsflyerSdk.onInstallConversionData((res) {
      print("AppsFlyer onInstallConversionData: " + res.toString());
    });

    _appsflyerSdk.onAppOpenAttribution((res) {
      print("AppsFlyer onAppOpenAttribution: " + res.toString());
    });

    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          print("AppsFlyer DeepLink found: ${dp.deepLink?.toString()}");
          break;
        case Status.NOT_FOUND:
          print("AppsFlyer DeepLink not found");
          break;
        case Status.ERROR:
          print("AppsFlyer DeepLink error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("AppsFlyer DeepLink parse error");
          break;
      }
    });

    // Initialize SDK - will auto start since manualStart is false
    await _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    // Get AppsFlyer UID for debugging
    String? uid = await _appsflyerSdk.getAppsFlyerUID();
    print("AppsFlyer UID: $uid");
    print("AppsFlyer: SDK initialized");
  }

  Future<void> _initFacebookAppEvents() async {
    // Initialize Facebook App Events
    facebookAppEvents = FacebookAppEvents();

    final deviceInfo = DeviceInfoPlugin();
    final connectivity = Connectivity();

    // Fetch package info, connectivity result, and device info concurrently.
    // Previously these awaited each other sequentially which added ~3
    // round-trips of platform-channel latency to startup.
    final results = await Future.wait<dynamic>([
      PackageInfo.fromPlatform(),
      connectivity.checkConnectivity(),
      if (Platform.isAndroid)
        deviceInfo.androidInfo
      else if (Platform.isIOS)
        deviceInfo.iosInfo
      else
        Future<dynamic>.value(null),
    ]);

    final packageInfo = results[0] as PackageInfo;
    final connectivityResult = results[1];
    final platformInfo = results[2];

    String deviceModel = 'unknown';
    String osVersion = 'unknown';
    String deviceId = 'unknown';

    if (Platform.isAndroid && platformInfo is AndroidDeviceInfo) {
      deviceModel = platformInfo.model ?? 'unknown';
      osVersion = platformInfo.version.release ?? 'unknown';
      deviceId = platformInfo.id ?? 'unknown';
    } else if (Platform.isIOS && platformInfo is IosDeviceInfo) {
      deviceModel = platformInfo.model ?? 'unknown';
      osVersion = platformInfo.systemVersion ?? 'unknown';
      deviceId = platformInfo.identifierForVendor ?? 'unknown';
    }
    
    // Log app activation event with dynamic parameters
    await facebookAppEvents.logEvent(
      name: 'fb_mobile_activate_app',
      parameters: {
        'fb_content_type': 'app',
        'fb_content_id': 'experts_event_app',
        'fb_currency': 'USD',
        'fb_value': '1.0',
        'fb_registration_method': 'organic',
        'fb_first_open': 'true',
        'fb_time': DateTime.now().millisecondsSinceEpoch.toString(),
        'fb_device_id': deviceId,
        'fb_os_version': osVersion,
        'fb_app_version': packageInfo.version,
        'fb_sdk_version': '0.19.2',
        'fb_device_model': deviceModel,
        'fb_network_type': connectivityResult.toString().split('.').last, // Dynamic network type
        'fb_language': Platform.localeName.split('_')[0], // Dynamic language from device locale
        'fb_timezone': DateTime.now().timeZoneName,
      },
    );
    
    print("Facebook App Events initialized with dynamic data");
    print("Device: $deviceModel, OS: $osVersion, App: ${packageInfo.version}");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IntroCubit()),
        BlocProvider(create: (context) => AuthCubit()..profile()),
        BlocProvider(create: (context) => ForgetPassCubit()),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(
            create: (context) => AddEventCubit()
              ..eventTypes()
              ..showHidePayment()),
        BlocProvider(create: (context) => GuardsCubit()),
        BlocProvider(
            create: (context) => HomeCubit()
              ..getEvents()
              ..getUsertype()
              ..getUserPhone()..showHideAds),
        BlocProvider(create: (context) => InvitationsCubit()),
        BlocProvider(create: (context) => EventsCubit()),
        BlocProvider(
            create: (context) => MoreCubit()
              ..getUserEvents()
              ..getUsertype()
              ..getUserPhone()),
        BlocProvider(create: (context) => WalletCubit()..getWallet()),
      ],
      child: MaterialApp(
        title: 'Experts Event',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          scaffoldBackgroundColor: AppUI.whiteColor,
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: AppUI.disableColor)),
          primarySwatch: AppUI.mainColor,
          primaryColor: AppUI.mainColor,
          textTheme:
              GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
            bodyLarge: GoogleFonts.roboto(
                textStyle: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        home: const SplashScreen(), //NetworkListener(child: SplashScreen())
      ),
    );
  }
}

/// A small top-level widget that listens to `NetworkInfo.stream` and shows
/// a persistent SnackBar when the device goes offline and a brief message
/// when it comes back online.
class NetworkListener extends StatefulWidget {
  final Widget child;
  const NetworkListener({Key? key, required this.child}) : super(key: key);

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  late final StreamSubscription<bool> _sub;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _offlineSnack;

  @override
  void initState() {
    super.initState();
    _sub = NetworkInfo.stream.listen((connected) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      if (!connected) {
        // show a persistent offline message
        _offlineSnack = messenger.showSnackBar(const SnackBar(
          content: Text('No internet connection'),
          duration: Duration(days: 1), // effectively persistent until dismissed
        ));
        print('No internet connection');
      } else {
        // dismiss offline snack if present and show a short online message
        _offlineSnack?.close();
        messenger.showSnackBar(const SnackBar(
          content: Text('Back online'),
          duration: Duration(seconds: 2),
        ));
        print('internet connection');
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
