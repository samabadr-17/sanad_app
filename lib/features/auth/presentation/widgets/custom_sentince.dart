
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';

// Custom sentence with a clickable text
class CustomSentince extends StatelessWidget {
  const CustomSentince({
    super.key,
    required this.text1,
    required this.text2,
    required this.onTap,
  });

  // Display texts and tap callback
  final String text1;
  final String text2;
  final VoidCallback onTap;

  // Build custom sentence
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First text
          AppText(
            text1,
            style: TextStyle(fontSize: 11.sp),
          ),

          // Clickable second text
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: AppText(
              text2,
              style: TextStyle(
                fontSize: 11.sp,
                color: DarkTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
