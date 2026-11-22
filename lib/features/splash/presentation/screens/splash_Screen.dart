import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!mounted) return;
      final loggedIn = Supabase.instance.client.auth.currentSession != null;
      context.go(loggedIn ? '/home' : '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Sanad house · Soft rise.png', width: 84.w)
                .animate()
                .fadeIn(duration: 2000.ms, curve: Curves.easeInOut)
                .slideY(begin: 0.2, end: 0, duration: 2000.ms, curve: Curves.easeOutCubic),
            SizedBox(height: 24.h),
            IntrinsicWidth(
              child: Column(
                spacing: 1,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: TextStyle(
                      fontSize: 64.sp,
                      height: 1.h,
                      fontWeight: FontWeight.bold,
                      color: DarkTeal,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 4.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color:DarkTeal,
                    ),
                  ),
                ],
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 1500.ms, curve: Curves.easeInOut)
                  .slideY(begin: 0.15, end: 0, duration: 1500.ms, curve: Curves.easeOutCubic),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.splashTagline,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: SplashText,
              ),
            )
                .animate(delay: 900.ms)
                .fadeIn(duration: 1300.ms, curve: Curves.easeInOut)
                .slideY(begin: 0.12, end: 0, duration: 1300.ms, curve: Curves.easeOutCubic),
            SizedBox(height: 80.h),
            SpinKitThreeBounce(color:DimGray, size: 14.sp)
                .animate(delay: 1400.ms)
                .fadeIn(duration: 1000.ms, curve: Curves.easeInOut),
            SizedBox(height: 12.h),
            Text(
              AppLocalizations.of(context)!.splashFooter,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF8A8A8A)),
            )
                .animate(delay: 1800.ms)
                .fadeIn(duration: 1100.ms, curve: Curves.easeInOut)
                .slideY(begin: 0.1, end: 0, duration: 1100.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}