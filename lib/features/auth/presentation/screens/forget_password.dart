import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/features/auth/data/repo/auth.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_Button.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_appbarText.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textFormField.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textLabel.dart';
import 'package:sanad/l10n/app_localizations.dart';

// Forget password screen
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // Form controllers
  final emailController = TextEditingController();
  final globKey = GlobalKey<FormState>();

  // Loading state
  bool isLoading = false;

  // Dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Cream,

        // App bar
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Cream,
          title: CustomAppbartext(
            text: AppLocalizations.of(context)!.forgotPasswordTitle,
          ),
        ),

        // Page content
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email label
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: CustomTextlabel(
                            text: AppLocalizations.of(context)!.enterYourEmail,
                          ),
                        ),

                        // Email input field
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Form(
                            key: globKey,
                            child: CustomTextformfield(
                              validator: Validators.email,
                              keyboardType: TextInputType.emailAddress,
                              isPassword: false,
                              controller: emailController,
                              bordercolor: Rust,
                              text: 'example@gmail.com',
                              icon: Icons.email_outlined,
                              fillcolor: SeaShell,
                            ),
                          ),
                        ),

                        // Button spacing
                        SizedBox(height: 10.h),

                        // Send OTP button
                        InkWell(
                          onTap: () async {
                            if (isLoading) return;
                            if (!globKey.currentState!.validate()) return;

                            setState(() => isLoading = true);

                            final email = emailController.text.trim();
                            final ok = await Auth().sendOtp(email, context);

                            if (!mounted) return;
                            setState(() => isLoading = false);

                            // Navigate to OTP screen
                            if (ok) context.push('/otpScreen', extra: email);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: CustomButton(
                              text: AppLocalizations.of(context)!.sendOtpButton,
                              isLoading: isLoading,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
