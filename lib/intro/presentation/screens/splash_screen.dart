import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';

import '../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../core/app_util.dart';
import '../../../core/calendar_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../home/presentation/controller/home_cubit.dart';
import '../../../more/presentation/controller/more_cubit.dart';
import '../controller/intro_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _smartlookProjectKey =
      '5499f45fab81a50cc61cf8dacc655f5bb3fdfb2b';

  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    // Touch the cubits so their providers are kept alive once the user
    // reaches the layout. These calls are cheap (no awaits, no I/O) and
    // safe to run synchronously on the first frame.
    AddEventCubit.get(context);
    MoreCubit.get(context);
    HomeCubit.get(context).showHideAds();

    // Defer everything that touches platform channels (Smartlook,
    // permission dialogs, etc.) until AFTER the first frame is on screen
    // so the splash paints immediately instead of waiting on plugin work.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;

    // Smartlook is fire-and-forget; it must never block navigation.
    unawaited(_initSmartlookSafe());

    // Run permission requests concurrently. Each is wrapped to ensure
    // a denial / error never prevents the user from leaving the splash.
    await Future.wait<void>([
      _safe(() => AppUtil().getContactPermission(),
          label: 'contact permission'),
      _safe(() => CalendarUtils.requestCalendarPermission(),
          label: 'calendar permission'),
    ]);

    if (!mounted) return;
    IntroCubit.get(context).navigateToNextScreen(context);
  }

  Future<void> _initSmartlookSafe() async {
    try {
      final smartlook = Smartlook.instance;
      smartlook.preferences.setProjectKey(_smartlookProjectKey);
      smartlook.start();
    } catch (e) {
      debugPrint('Smartlook init error: $e');
    }
  }

  Future<void> _safe(Future<dynamic> Function() task,
      {required String label}) async {
    try {
      await task();
    } catch (e) {
      debugPrint('$label error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    // Decode the heavy splash background at the device's native pixel
    // resolution instead of the asset's full bitmap size. This drastically
    // reduces decode time and memory on the first frame.
    final int bgCacheWidth =
        (size.width * dpr).clamp(1, 4096).round();
    // Decode the logo at its actual rendered size (250 logical px) for
    // the same reason.
    final int logoCacheWidth = (250 * dpr).clamp(1, 1024).round();

    return Scaffold(
      // Match the splash artwork's dominant tone so any pixel not covered
      // by the PNG (transparent edges, safe-area padding on certain
      // aspect ratios) blends in instead of flashing white.
      backgroundColor: AppUI.mainColor,
      body: Stack(
        // Force the Stack to fill all available space from the Scaffold
        // body. Without this the Stack would shrink-wrap around its
        // non-positioned children (the Column below) and Positioned.fill
        // would only cover that small region instead of the whole screen.
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Image.asset(
            "${AppUI.imgPath}splash3.png",
            // BoxFit.fill matches the original behavior and guarantees
            // the image covers the whole screen with no gaps.
            fit: BoxFit.fill,
            cacheWidth: bgCacheWidth,
            gaplessPlayback: true,
            filterQuality: ui.FilterQuality.medium,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "${AppUI.imgPath}logo.png",
                height: 250,
                width: 250,
                cacheWidth: logoCacheWidth,
                gaplessPlayback: true,
                filterQuality: ui.FilterQuality.medium,
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppUI.mainColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
