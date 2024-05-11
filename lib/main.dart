import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:in_app_update/in_app_update.dart';
import 'common/functions/functions.dart';
import 'config/re_captcha_v3_provider_keys.dart';
import 'core/colors.dart';
import 'core/strings.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider(reCaptchaV3ProviderSiteKey),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
      webProvider: ReCaptchaV3Provider(reCaptchaV3ProviderSiteKey),
    );
  }
  if (!kIsWeb) {
    FlutterError.onError = (errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isAndroid) {
      checkForUpdate();
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        }
      });
    }).catchError((e) {
      showCustomSnackBar(message: e.toString());
    });
  }

  void update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      showCustomSnackBar(message: e.toString());
    });
  }

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
