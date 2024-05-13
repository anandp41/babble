import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'common/functions/functions.dart';
import 'config/re_captcha_v3_provider_keys.dart';
import 'core/colors.dart';
import 'core/strings.dart';
// import 'package:babble/common/functions/functions.dart';
import 'firebase_options.dart';

Future<void> main() async {
  log("1");
  WidgetsFlutterBinding.ensureInitialized();
  log("2");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider(reCaptchaV3ProviderSiteKey),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
    log("3a");
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
      webProvider: ReCaptchaV3Provider(reCaptchaV3ProviderSiteKey),
    );
    log("3b");
  }

  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    log("4");
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    log("5");
  }
  log("6");
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      title: appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: bodyBackgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: babbleTitleColor),
        useMaterial3: true,
      ),
      home: platformHandler(),
      debugShowCheckedModeBanner: false,
    );
  }
}
