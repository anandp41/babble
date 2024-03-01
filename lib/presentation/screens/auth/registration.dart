import 'dart:developer';

import 'package:babble/presentation/common/appbar.dart';
import 'package:babble/presentation/screens/auth/otpscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/padding.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80), child: CustomAppBarBabble()),
      body: SafeArea(
          child: Padding(
        padding: regOtpScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome! Glad to see you!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: regTitleColor,
                  fontFamily: 'Urbanist',
                  fontSize: 35,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: regOtpFieldBgColor,
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(
                      fontFamily: 'Urbanist', fontSize: 15, color: otpSubColor),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException ex) {
                      log(ex.toString());
                    },
                    codeSent:
                        (String verificationId, int? forceResendingToken) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OTPScreen(verificationId: verificationId),
                          ));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    phoneNumber: "+91${phoneNumberController.text}");
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
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OTPScreen(verificationId: "asdsds"),
                      ));
                },
                child: const Text("OTP"))
          ],
        ),
      )),
    );
  }
}
