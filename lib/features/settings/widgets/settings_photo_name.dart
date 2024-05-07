import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/colors.dart';
import '../../../core/textstyles.dart';
import '../../../models/user_model.dart';
import 'functions.dart';

class SettingsNamePanel extends StatelessWidget {
  const SettingsNamePanel(
      {super.key, required this.ref, required this.userData});
  final UserModel userData;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Name",
            style: TextStyle(
                fontFamily: 'Hind', fontSize: 13, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  userData.name,
                  style: settingsNamePreviewTS,
                ),
              ),
              IconButton(
                  onPressed: () {
                    showNameBottomSheet(context, userData, ref);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: babbleTitleColor,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
