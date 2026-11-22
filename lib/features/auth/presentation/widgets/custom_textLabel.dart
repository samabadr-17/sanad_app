
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';

// Custom text label
class CustomTextlabel extends StatelessWidget {
  const CustomTextlabel({super.key, required this.text});

  // Label text
  final String text;

  // Build text label
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: AppText(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: DarkTeal,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
