import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Auth {
  final supa = Supabase.instance.client.auth;

  // -------------------------------------- Login -----------------------------------------
  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await supa.signInWithPassword(email: email, password: password);
      if (!context.mounted) return false;
      return true;
    } on AuthException catch (e) {
      if (!context.mounted) return false;

      String message;
      if (e.code == 'invalid_credentials' ||
          e.message.toLowerCase().contains('invalid login credentials')) {
        message = 'Incorrect email or password.';
      } else if (e.code == 'email_not_confirmed' ||
          e.message.toLowerCase().contains('email not confirmed')) {
        message = 'Please confirm your email first. Check your inbox.';
      } else {
        message = 'Login failed. Please try again.';
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: message,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Login failed. Please check your connection and try again.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
      return false;
    }
  }

  // -------------------------------------- SignUp -----------------------------------------
  Future<bool> signup(
    String name,
    String email,
    String city,
    String region,
    String password,
    BuildContext context,
  ) async {
    try {
      final res = await supa.signUp(
        password: password,
        email: email,
        data: {'name': name, 'city': city, 'region': region},
      );

      if (!context.mounted) return false;

      // إيميل متسجل قبل كده
      if (res.user != null && (res.user!.identities?.isEmpty ?? false)) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'This email is already registered. Try logging in instead.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
        return false;
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Account created. Please check your email to confirm it.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      return true;
    } on AuthException catch (e) {
      if (!context.mounted) return false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Sign up failed. Please check your connection and try again.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
      return false;
    }
  }

  // -------------------------------------- Send Otp ---------------------------------------
  Future<bool> sendOtp(String email, BuildContext context) async {
    try {
      await supa.resetPasswordForEmail(email);
      if (!context.mounted) return false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'We sent a code to your email',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      return true;
    } on AuthException catch (e) {
      if (!context.mounted) return false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Could not send the code. Please check your connection and try again.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      return false;
    }
  }

  // -------------------------------------- verifyOtp --------------------------------------
  Future<void> verifyOtp(String email, String otp, BuildContext context) async {
    try {
      await supa.verifyOTP(email: email, token: otp, type: OtpType.recovery);
      if (!context.mounted) return;
      context.go('/newPassword');
    } on AuthException catch (e) {
      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Could not verify the code. Please check your connection and try again.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }

  // -------------------------------------- Reset Password ----------------------------------
  Future<void> resetPassword(String newpass, BuildContext context) async {
    try {
      await supa.updateUser(UserAttributes(password: newpass));
      await supa.signOut();
      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Password updated successfully',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();

      context.go('/finishOtp');
    } on AuthException catch (e) {
      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      if (!context.mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Could not update your password. Please check your connection and try again.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }
}
