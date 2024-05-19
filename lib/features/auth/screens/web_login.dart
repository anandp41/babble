import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/misc.dart';
import '../../../../../core/textstyles.dart';
import '../../../common/functions/functions.dart';
import '../../../common/widgets/otp_appbar.dart';
import '../../../core/strings.dart';
import '../controller/auth_controller.dart';
import '../widgets/phone_number_field.dart';

class WebLoginScreen extends ConsumerStatefulWidget {
  const WebLoginScreen({super.key});

  @override
  ConsumerState<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends ConsumerState<WebLoginScreen> {
  var phoneNumberController = TextEditingController();
  CountryCode? country;
  Future<void> isThisPhoneRegistered() async {
    String phoneNumber = phoneNumberController.text.trim();
    if (phoneNumber.isNotEmpty) {
      bool isPhoneRegd = await ref
          .read(authControllerProvider)
          .isThisPhoneRegistered(phoneNumber: country!.dialCode! + phoneNumber);
      if (isPhoneRegd) {
        await ref
            .read(authControllerProvider)
            .signInWithPhone(country!.dialCode! + phoneNumber);
      } else {
        showCustomSnackBar(message: "This number is not registered on Babble");
      }
    } else {
      showCustomSnackBar(message: "Enter valid phone number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomOTPAppBar(
            backArrow: false,
          )),
      body: SafeArea(
          child: Padding(
        padding: regOtpScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(regPageWelcomeMessage,
                textAlign: TextAlign.left, style: regOTPScreenBannerTextStyle),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                constraints: registrationPhoneEntryBoxConstraint,
                decoration: BoxDecoration(
                    color: regOtpFieldBgColor,
                    borderRadius: BorderRadius.circular(messageBorderRadius)),
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
                    PhoneNumberField(
                        phoneNumberController: phoneNumberController),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await isThisPhoneRegistered();
                },
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(messageBorderRadius))),
                    fixedSize: const WidgetStatePropertyAll(otpButtonFixedSize),
                    maximumSize: const WidgetStatePropertyAll(otpButtonMaxSize),
                    backgroundColor:
                        const WidgetStatePropertyAll(otpVerifyButtonBg)),
                child: const Text(
                  "Send OTP",
                  style: sendVerifyOTPButtonTextstyle,
                ),
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
