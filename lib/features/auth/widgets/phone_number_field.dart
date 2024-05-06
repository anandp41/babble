import 'package:flutter/material.dart';

import '../../../core/textstyles.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.phoneNumberController,
  });

  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        style: otpPhoneNumberTextStyle,
        keyboardType: TextInputType.number,
        controller: phoneNumberController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          hintText: 'Enter your phone number',
          hintStyle: registrationPhoneNumberTextStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
