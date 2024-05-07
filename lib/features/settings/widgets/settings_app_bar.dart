import 'package:flutter/material.dart';

import '../../../common/widgets/appbar_back_button.dart';
import '../../../core/colors.dart';
import '../../../core/textstyles.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: chatAppBarBg,
      centerTitle: false,
      leading: const AppBarBackButton(),
      title: const Text(
        'Settings',
        style: settingsAppBarTitleTS,
      ),
    );
  }
}
