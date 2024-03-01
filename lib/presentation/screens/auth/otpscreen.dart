import 'dart:developer';

import 'package:babble/presentation/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../core/colors.dart';
import '../../../core/padding.dart';
import '../../common/appbar.dart';

class OTPScreen extends StatefulWidget {
  String verificationId;
  OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(234, 239, 243, 1),
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80), child: CustomAppBarBabble()),
      backgroundColor: bodyBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: regOtpScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('OTP Verification',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: regTitleColor,
                  fontFamily: 'Urbanist',
                  fontSize: 35,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Enter the verification code we just sent on your email address.",
              style: TextStyle(
                  color: otpSubColor, fontFamily: "Urbanist", fontSize: 16),
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
            ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text);
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                  });
                } catch (ex) {
                  log(ex.toString());
                }
              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  fixedSize:
                      const MaterialStatePropertyAll(Size(double.infinity, 56)),
                  maximumSize: const MaterialStatePropertyAll(Size(1200, 56)),
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF9E8585))),
              child: const Text(
                "Send OTP",
                style: TextStyle(
                    color: kWhite,
                    fontSize: 15,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
