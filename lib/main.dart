import 'package:babble/core/colors.dart';
import 'package:babble/presentation/screens/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'firebase_options.dart';

Future<void> createEngine() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
  //   appId,
  //   ZegoScenario.StandardVoiceCall,
  //   appSign: appSign,
  // ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  createEngine();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      title: 'Babble',
      theme: ThemeData(
        scaffoldBackgroundColor: bodyBackgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: babbleTitleColor),
        useMaterial3: true,
      ),
      home: const ScreenSplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
