import 'package:babble/controller/auth_controller.dart';
import 'package:babble/presentation/screens/home/bottom_nav_bar/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import 'package:babble/presentation/screens/home/tabs/contacts/screen/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/colors.dart';
import '../../common/appbars/home_appbar.dart';
import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'tabs/chats list/screen/chat_list_screen.dart';
import 'tabs/rooms list/rooms_list_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const List<Widget> tabs = [
    ContactsScreen(),
    ChatsListScreen(),
    RoomsListScreen()
  ];

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: false,
      backgroundColor: bodyBackgroundColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70), child: CustomHomeAppBar()),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
                builder: (context, state) {
                  return Home.tabs[state.tabIndex];
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
                  builder: (context, state) {
                    return CustomNavBar(
                      activeIndex: state.tabIndex,
                    );
                  },
                ))
          ],
        ),
      )),
    );
  }
}
