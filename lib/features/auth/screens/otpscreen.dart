import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/otp_pin_theme.dart';
import '../../../../../core/misc.dart';
import '../../../../../core/textstyles.dart';
import '../../../common/widgets/otp_appbar.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final otpController = TextEditingController();
  List args = Get.arguments;
  Future<void> verifyOTP(WidgetRef ref, String otp) async {
    String verificationId = args[0];
    String phoneNumber = args[1];
    await ref.read(authControllerProvider).verifyOTP(
        verificationId: verificationId, otp: otp, phoneNumber: phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70), child: CustomOTPAppBar()),
      backgroundColor: bodyBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: regOtpScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('OTP Verification',
                textAlign: TextAlign.left, style: regOTPScreenBannerTextStyle),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Enter the OTP received on your phone.",
              style: otpScreenHeadingTextStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Pinput(
                keyboardType: TextInputType.number,
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                length: 6,
                controller: otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                showCursor: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (kIsWeb) {
                    await ref
                        .read(authControllerProvider)
                        .verifyOTPWeb(otp: otpController.text.trim());
                  } else {
                    await verifyOTP(ref, otpController.text.trim());
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    fixedSize: const MaterialStatePropertyAll(
                        Size(double.infinity, 56)),
                    maximumSize: const MaterialStatePropertyAll(Size(1200, 56)),
                    backgroundColor:
                        const MaterialStatePropertyAll(otpVerifyButtonBg)),
                child: const Text(
                  "Verify",
                  style: sendVerifyOTPButtonTextstyle,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
