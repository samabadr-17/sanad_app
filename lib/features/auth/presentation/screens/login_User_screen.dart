import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';
import 'package:sanad/features/auth/data/repo/auth.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_Button.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_appbar.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_appbarText.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_sentince.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textFormField.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textLabel.dart';
import 'package:sanad/l10n/app_localizations.dart';

// Login screen
class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({super.key});

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  // Form key and input controllers
  final globKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading state
  bool isLoading = false;

  // Dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Build login screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // App bar
        appBar: AppBar(
          backgroundColor: Cream,
          title: Row(
            children: [
              CustomAppbar(image: 'assets/images/Sanad house · Soft rise.png'),
              CustomAppbartext(text: AppLocalizations.of(context)!.appName),
            ],
          ),
        ),
        backgroundColor: Cream,

        // Login page content
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Page title and subtitle
                SizedBox(height: 20.h),
                CustomAppbartext(
                  text: AppLocalizations.of(context)!.loginTitle,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: AppText(
                    AppLocalizations.of(context)!.loginSubtitle,
                    style: TextStyle(color: DimGray),
                  ),
                ),
                SizedBox(height: 50.h),

                // Login form
                Form(
                  key: globKey,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field
                        CustomTextlabel(
                          text: AppLocalizations.of(context)!.email,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextformfield(
                          validator: Validators.email,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          bordercolor: Rust,
                          icon: Icons.email_outlined,
                          text: AppLocalizations.of(context)!.hintEmail,
                          fillcolor: SeaShell,
                        ),
                        SizedBox(height: 10.h),

                        // Password field
                        CustomTextlabel(
                          text: AppLocalizations.of(context)!.password,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextformfield(
                          validator: Validators.loginPassword,
                          isPassword: true,
                          controller: passwordController,
                          bordercolor: Rust,
                          icon: Icons.visibility_off_outlined,
                          text: '••••••••',
                          fillcolor: SeaShell,
                        ),
                      ],
                    ),
                  ),
                ),

                // Forgot password link
                InkWell(
                  onTap: () => context.push('/forgetPassword'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: AppText(
                      AppLocalizations.of(context)!.forgotPasswordLink,
                      style: TextStyle(
                        color: Rust,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Login button
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: InkWell(
                      onTap: () async {
                        if (isLoading) return;
                        if (!globKey.currentState!.validate()) return;

                        setState(() => isLoading = true);
                        final ok = await Auth().login(
                          emailController.text.trim(),
                          passwordController.text,
                          context,
                        );
                        if (!mounted) return;
                        setState(() => isLoading = false);

                        // Navigate after successful login
                        if (ok) context.go('/clientHome');
                      },
                    child: CustomButton(
                      text: AppLocalizations.of(context)!.loginButton,
                      isLoading: isLoading,
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                // Data security notice
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: StoneWhite,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Rust, width: 1.r),
                    ),
                    child: Row(
                      spacing: 2.w,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/shield-check.png',
                          height: 25.h,
                          width: 25.w,
                        ),
                        Expanded(
                          child: CustomTextlabel(
                            text: AppLocalizations.of(context)!
                                .dataSecurityNote,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                // Sign up link
                CustomSentince(
                  onTap: () => context.go('/signUp'),
                  text1: AppLocalizations.of(context)!.firstTimeHere,
                  text2: AppLocalizations.of(context)!.createNewAccount,
                ),
                SizedBox(height: 15.h),

                // Terms and conditions
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: AppText(
                    AppLocalizations.of(context)!.termsAgreementNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: DimGray),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
