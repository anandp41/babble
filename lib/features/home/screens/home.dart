import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/providers/bottom_nav_bar_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../../chat/screens/chat_list_screen.dart';
import '../../room/screens/rooms_list_screen.dart';
import '../widgets/home_appbar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_floating_action_button.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const List<Widget> tabs = [
    ChatsListScreen(),
    RoomsListScreen(),
  ];

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(userDataAuthProvider);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        await ref.read(authControllerProvider).setUserState(false);
        await ref
            .read(authControllerProvider)
            .removePhoneFromAllSpeakingList(ref: ref);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: false,
      // backgroundColor: bodyBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomHomeAppBar(),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: IndexedStack(
                  index: indexBottomNavbar,
                  children: Home.tabs,
                )),
            Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomFloatingActionButton(
                      isRoomsList: indexBottomNavbar == 1,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomNavBar(
                      activeIndex: indexBottomNavbar,
                    ),
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
