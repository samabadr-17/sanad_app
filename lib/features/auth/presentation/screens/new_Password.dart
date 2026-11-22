import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/features/auth/data/repo/auth.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_Button.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_appbarText.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textFormField.dart';
import 'package:sanad/features/auth/presentation/widgets/custom_textLabel.dart';
import 'package:sanad/l10n/app_localizations.dart';

// New password screen
class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  // Password controller and form key
  final passController = TextEditingController();
  final globKey = GlobalKey<FormState>();

  // Loading state
  bool isLoading = false;

  // Dispose controller
  @override
  void dispose() {
    passController.dispose();
    super.dispose();
  }

  // Build new password screen
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
            text: AppLocalizations.of(context)!.newPasswordTitle,
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Password instruction
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: CustomTextlabel(
                            text: AppLocalizations.of(context)!
                                .enterNewPassword,
                          ),
                        ),

                        // Password form
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Form(
                            key: globKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // New password field
                                CustomTextformfield(
                                  validator: Validators.password,
                                  isPassword: true,
                                  controller: passController,
                                  bordercolor: Rust,
                                  fillcolor: SeaShell,
                                  icon: Icons.visibility_off_outlined,
                                  text: '••••••••',
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),

                        // Done button
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () async {
                            if (isLoading) return;
                            if (!globKey.currentState!.validate()) return;

                            setState(() => isLoading = true);
                            await Auth().resetPassword(
                              passController.text,
                              context,
                            );
                            if (!mounted) return;
                            setState(() => isLoading = false);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: CustomButton(
                              text: AppLocalizations.of(context)!.doneButton,
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
