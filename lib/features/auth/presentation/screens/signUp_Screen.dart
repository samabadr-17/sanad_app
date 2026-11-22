import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';
import 'package:sanad/features/auth/data/repo/auth.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_Button.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_appbarText.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_sentince.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textFormField.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textLabel.dart';
import 'package:sanad/l10n/app_localizations.dart';

// Sign up screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form key
  final globKey = GlobalKey<FormState>();

  // Form input controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final regionController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading and privacy agreement states
  bool isChecked = false;
  bool isLoading = false;

  // Dispose controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    regionController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Build sign up screen
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
            text: AppLocalizations.of(context)!.registerTitle,
          ),
        ),

        // Registration page content
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Page subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AppText(
                    AppLocalizations.of(context)!.registerSubtitle,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Registration form
                Form(
                  key: globKey,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Full name field
                        CustomTextlabel(
                          text: AppLocalizations.of(context)!.fullName,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextformfield(
                          validator: Validators.name,
                          controller: nameController,
                          bordercolor: Rust,
                          icon: Icons.person,
                          text: AppLocalizations.of(context)!.hintFullName,
                          fillcolor: SeaShell,
                        ),
                        SizedBox(height: 15.h),

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
                        SizedBox(height: 15.h),

                        // City field
                        CustomTextlabel(
                          text: AppLocalizations.of(context)!.city,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextformfield(
                          validator: Validators.city,
                          controller: cityController,
                          bordercolor: Rust,
                          icon: Icons.location_on_outlined,
                          text: AppLocalizations.of(context)!.hintCity,
                          fillcolor: SeaShell,
                        ),
                        SizedBox(height: 15.h),

                        // Area field
                        CustomTextlabel(
                          text: AppLocalizations.of(context)!.area,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextformfield(
                          validator: Validators.area,
                          controller: regionController,
                          bordercolor: Rust,
                          icon: Icons.location_on_outlined,
                          text: AppLocalizations.of(context)!.hintArea,
                          fillcolor: SeaShell,
                        ),
                        SizedBox(height: 15.h),

                        // Password field
                        CustomTextlabel(
                          text: AppLocalizations.of(context)!.password,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextformfield(
                          validator: Validators.password,
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

                // Privacy policy agreement
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: AppText(
                          AppLocalizations.of(context)!.agreeToPrivacyAndTerms,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: DarkTeal,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Create account button
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: InkWell(
                    onTap: () async {
                      if (isLoading) return;
                      if (!globKey.currentState!.validate()) return;

                      // Check privacy policy agreement
                      if (!isChecked) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Warning',
                          desc: 'Please Accept Privacy Policy',
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      setState(() => isLoading = true);
                      final ok = await Auth().signup(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        cityController.text.trim(),
                        regionController.text.trim(),
                        passwordController.text,
                        context,
                      );
                      if (!mounted) return;
                      setState(() => isLoading = false);

                      // Navigate after successful registration
                      if (ok) context.go('/loginUser');
                    },
                    child: CustomButton(
                      text: AppLocalizations.of(context)!.createAccountButton,
                      isLoading: isLoading,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Login link for existing users
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: CustomSentince(
                    onTap: () => context.go('/loginUser'),
                    text1: AppLocalizations.of(context)!.haveAccount,
                    text2: AppLocalizations.of(context)!.loginButton,
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
