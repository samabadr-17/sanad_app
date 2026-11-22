import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/features/auth/data/repo/auth.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_Button.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_appbarText.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textFormField.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textLabel.dart';
import 'package:sanad/l10n/app_localizations.dart';

// OTP verification screen
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Form key and OTP controller
  final globKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  // Loading state
  bool isLoading = false;

  // Dispose controller
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  // Build OTP screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Cream,

        // App bar
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Cream,
          title: CustomAppbartext(text: AppLocalizations.of(context)!.otpTitle),
        ),

        // OTP page content
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // OTP instruction message
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: CustomTextlabel(
                      text: AppLocalizations.of(context)!.otpMessage,
                    ),
                  ),

                  // OTP input form
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Form(
                      key: globKey,
                      child: CustomTextformfield(
                        validator: Validators.otp,
                        keyboardType: TextInputType.number,

                        // Allow digits only and limit input to 6 characters
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        controller: otpController,
                        bordercolor: Rust,
                        text: '384591',
                        fillcolor: SeaShell,
                      ),
                    ),
                  ),

                  // Verify button
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () async {
                      if (isLoading) return;
                      if (!globKey.currentState!.validate()) return;

                      setState(() => isLoading = true);
                      await Auth().verifyOtp(
                        widget.email,
                        otpController.text,
                        context,
                      );
                      if (!mounted) return;
                      setState(() => isLoading = false);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: CustomButton(
                        text: AppLocalizations.of(context)!.verifyOtpButton,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
