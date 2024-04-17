import 'package:babble/controller/auth_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:babble/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'presentation/screens/widgets/error_screen.dart';
import 'presentation/screens/widgets/loader.dart';
import 'firebase_options.dart';

import 'presentation/screens/auth/registration.dart';
import 'presentation/screens/home/bottom_nav_bar/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';

// import 'presentation/screens/screen_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   // Set androidProvider to `AndroidProvider.debug`
  //   androidProvider: AndroidProvider.debug,
  // );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      title: 'Babble',
      theme: ThemeData(
        scaffoldBackgroundColor: bodyBackgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: babbleTitleColor),
        useMaterial3: true,
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const RegistrationScreen();
              }
              return BlocProvider(
                create: (context) => BottomNavBarBloc(),
                child: const Home(),
              );
            },
            error: (error, stackTrace) {
              return ErrorScreen(error: error.toString());
            },
            loading: () => const Loader(),
          ),
      debugShowCheckedModeBanner: false,
    );
  }
}
