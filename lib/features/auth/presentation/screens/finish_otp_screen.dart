import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_Button.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_sentince.dart';
import 'package:sanad/l10n/app_localizations.dart';

// OTP success screen
class FinishOtpScreen extends StatelessWidget {
  const FinishOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Cream,

        // Main content
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success message and login link
              CustomSentince(
                onTap: () {
                  context.go('/loginUser');
                },
                text1: AppLocalizations.of(context)!.passwordResetSuccessPrefix,
                text2: AppLocalizations.of(context)!.loginButton,
              ),

              // Spacing
              SizedBox(height: 10.h),

              // Back to login button
              InkWell(
                onTap: () {
                  context.go('/loginUser');
                },
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: CustomButton(
                    text: AppLocalizations.of(context)!.goToLoginButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
