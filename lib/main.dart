import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'common/functions/functions.dart';
import 'core/colors.dart';
import 'core/strings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCvyR5rx84n-_eDImC9hKUQk3od3fEqRLk",
        authDomain: "babble-23d3e.firebaseapp.com",
        projectId: "babble-23d3e",
        storageBucket: "babble-23d3e.appspot.com",
        messagingSenderId: "953387577807",
        appId: "1:953387577807:web:9822a4702c0fca029fe2ba",
        measurementId: "G-02N225WXE8"),
  );
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
