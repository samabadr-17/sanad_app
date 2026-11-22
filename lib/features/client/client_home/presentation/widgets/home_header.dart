import 'package:flutter/material.dart';
import'../../../../../core/constants/colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          textDirection: TextDirection.ltr,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Rust,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: SeaShell,
                size: 20,
              ),
            ),

            Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عنوان الخدمة',
                  style: TextStyle(
                    fontSize: 16,
                    color: DimGray,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'مدينة نصر، القاهرة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DarkTeal,
                  ),
                ),
              ],
            ),

            SizedBox(width: 10),

            Icon(
              Icons.location_on_outlined,
              color: DarkTeal,
              size: 26,
            ),
          ],
        ),

        SizedBox(height: 16),

        // search bar ui only "no search logic for now"
        TextField(
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'تدور على أي خدمة؟',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(
              fontSize: 12,
              color: DimGray,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: DarkTeal,
              size: 22,
            ),
            filled: true,
            fillColor: Cream,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: DimGray,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
