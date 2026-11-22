import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class OnboardingAppbar extends StatelessWidget {
  final VoidCallback onSkip; // skip function
  final int
  currentIndex; // it takes current ndex as it changes the skip word to welcome

  const OnboardingAppbar({
    super.key,
    required this.onSkip,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Rust,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.home_outlined, size: 27, color: SeaShell),
          ),

          SizedBox(width: 10),

          Text(
            'سند',
            style: TextStyle(
              color: DarkTeal,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          Spacer(),

          // if we are in page 1 or 2 "not the last one 3" , show skip word and when we press it skip function work
          if (currentIndex < 2)
            TextButton(
              onPressed: onSkip,
              child: Text('تخطي', style: TextStyle(color: DimGray)),
            )
          else
            // if we are in the last page "3" show thw word welcome
            Text(
              'أهلاً بيك',
              style: TextStyle(
                fontSize: 16,
                color: DimGray,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
