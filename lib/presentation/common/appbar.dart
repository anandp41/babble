import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/colors.dart';

class CustomAppBarBabble extends StatelessWidget {
  const CustomAppBarBabble({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text(
        'Babble',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: babbleTitleColor,
            fontFamily: 'Jua',
            fontSize: 48,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 5),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/images/arrow1.svg')),
    );
  }
}
