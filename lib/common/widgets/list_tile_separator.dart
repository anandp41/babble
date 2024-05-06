import 'package:flutter/material.dart';

class ListTileSeparator extends StatelessWidget {
  const ListTileSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 15,
      color: Colors.black26,
      thickness: 1,
    );
  }
}