import 'package:flutter/material.dart';

import '../../../../../../../../../core/colors.dart';

class RoomControlDeleteButton extends StatelessWidget {
  const RoomControlDeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: roomMuteRedGradientColorsList),
        ),
        child: const Center(
          child: Text(
            "Delete Room",
            style: TextStyle(
                fontFamily: 'Hind',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
