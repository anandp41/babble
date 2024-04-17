import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bottom_nav_bar_icons.dart';
import 'bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';

class CustomNavBar extends StatelessWidget {
  final int activeIndex;
  const CustomNavBar({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
      builder: (context, state) {
        return Container(
          height: 70,
          margin: const EdgeInsets.only(
              //right: 25, left: 25,
              bottom: 10),
          decoration: BoxDecoration(
              color: const Color(0xFF9E8585),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    //offset: Offset(0, 0),
                    color: Colors.black38,
                    blurRadius: 10,
                    spreadRadius: 5)
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
                            log("Index $iconIndex");
                            BlocProvider.of<BottomNavBarBloc>(context)
                                .add(TabChange(tabIndex: iconIndex));
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
      },
    );
  }
}
