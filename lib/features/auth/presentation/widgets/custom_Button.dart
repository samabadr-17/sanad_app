
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';

// Custom reusable button
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.isLoading = false,
  });

  // Button text and loading state
  final String text;
  final bool isLoading;

  // Build custom button
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        // Button appearance
        borderRadius: BorderRadius.circular(10.r),
        color: Rust,
      ),
      // Show loading indicator or button text
      child: isLoading
          ? SizedBox(
              height: 24.h,
              width: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Cream,
              ),
            )
          : AppText(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Cream,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
