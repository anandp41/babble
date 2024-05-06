import 'package:flutter/material.dart';

import '../../../core/textstyles.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          error,
          style: roomControlMembersTitleTextStyle,
        ),
      ),
    );
  }
}
