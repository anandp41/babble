import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/textstyles.dart';
import 'functions.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        deleteAccountDialog(context, ref);
      },
      child: const ListTile(
        leading: Icon(
          Icons.delete_outlined,
          color: Colors.red,
        ),
        title: Text(
          "Delete account permanently",
          style: settingsButtonsTitleTS,
        ),
      ),
    );
  }
}
