import 'package:babble/controller/auth_controller.dart';
import 'package:babble/presentation/common/appbars/otp_appbar.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/colors.dart';
import '../../../core/misc.dart';
import '../../../core/textstyles.dart';

// ignore: must_be_immutable
class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  var phoneNumberController = TextEditingController();
  CountryCode? country;
  Future<void> sendPhoneNumber() async {
    String phoneNumber = phoneNumberController.text.trim();
    if (phoneNumber.isNotEmpty) {
      await ref
          .read(authControllerProvider)
          .signInWithPhone(country!.dialCode! + phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80), child: CustomOTPAppBar()),
      body: SafeArea(
          child: Padding(
        padding: regOtpScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome! Glad to see you!',
                textAlign: TextAlign.left, style: regOTPScreenBannerTextStyle),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: regOtpFieldBgColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: CountryCodePicker(
                      textStyle: otpPhoneNumberTextStyle,
                      padding: EdgeInsets.zero,
                      initialSelection: 'IN',
                      favorite: const ['IN'],
                      dialogTextStyle: otpPhoneNumberTextStyle,
                      onInit: (value) {
                        country = CountryCode.fromDialCode("+91");
                      },
                      onChanged: (value) {
                        country = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      style: otpPhoneNumberTextStyle,
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                        hintText: 'Enter your phone number',
                        hintStyle: registrationPhoneNumberTextStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await sendPhoneNumber();
              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  fixedSize:
                      const MaterialStatePropertyAll(Size(double.infinity, 56)),
                  maximumSize: const MaterialStatePropertyAll(Size(1200, 56)),
                  backgroundColor:
                      const MaterialStatePropertyAll(otpVerifyButtonBg)),
              child: const Text(
                "Send OTP",
                style: sendVerifyOTPButtonTextstyle,
              ),
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
