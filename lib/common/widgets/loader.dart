import 'package:flutter/material.dart';

import '../../core/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: babbleTitleColor,
        ),
      ),
    );
  }
}
