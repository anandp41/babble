import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/providers/bottom_nav_bar_provider.dart';
import '../../../../core/bottom_nav_bar_icons.dart';
import '../../../core/colors.dart';

class CustomNavBar extends ConsumerWidget {
  final int activeIndex;
  const CustomNavBar({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
          color: bottomNavBarColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                //offset: Offset(0, 0),
                color: Colors.black38,
                blurRadius: 3,
                spreadRadius: 1)
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcons.map((icon) {
          int iconIndex = navIcons.indexOf(icon);
          bool isSelected = iconIndex == activeIndex;
          return Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 35, right: 35),
                  child: IconButton(
                      onPressed: () {
                        ref
                            .watch(indexBottomNavbarProvider.state)
                            .update((state) => iconIndex);
                      },
                      icon: Icon(
                        icon,
                        size: 34,
                        color: isSelected ? Colors.white : Colors.white30,
                      )),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
