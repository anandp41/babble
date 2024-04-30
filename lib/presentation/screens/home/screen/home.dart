import 'package:babble/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/providers/bottom_nav_bar_provider.dart';
import '../../../../core/colors.dart';
import '../widgets/home_appbar.dart';
import '../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../widgets/custom_floating_action_button.dart';
import '../widgets/tabs/chats list/screen/chat_list_screen.dart';
import '../widgets/tabs/rooms list/screen/rooms_list_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const List<Widget> tabs = [
    ChatsListScreen(),
    //ChatsListScreen(),
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
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
      backgroundColor: bodyBackgroundColor,
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
