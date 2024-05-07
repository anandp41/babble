import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/textstyles.dart';
import 'functions.dart';

class AboutBabbleButton extends StatelessWidget {
  const AboutBabbleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        babbleAboutDialog(
          context,
        );
      },
      child: const ListTile(
        leading: Icon(
          Icons.info_outline,
          color: babbleTitleColor,
        ),
        title: Text(
          "App info",
          style: settingsButtonsTitleTS,
        ),
      ),
    );
  }
}
