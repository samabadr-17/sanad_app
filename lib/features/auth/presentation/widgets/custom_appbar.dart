
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Custom app bar image
class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, required this.image});

  // Image asset path
  final String image;

  // Build app bar image
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 40.w,
      child: ClipRRect(
        // Apply rounded corners to the image
        borderRadius: BorderRadius.circular(10.r),
        child: Image.asset(
          image,
          height: 15.h,
          width: 10.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
