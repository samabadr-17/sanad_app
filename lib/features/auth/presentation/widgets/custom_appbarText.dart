
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';

// Custom app bar text
class CustomAppbartext extends StatelessWidget {
  const CustomAppbartext({super.key, required this.text});

  // Text to display
  final String text;

  // Build app bar text
  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: DarkTeal,
        fontSize: 25.sp,
      ),
    );
  }
}
