import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      children: [
        Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                  l10n.homeAddressTitle,
                  style: TextStyle(fontSize: 16, color: DimGray),
                ),
                SizedBox(height: 3),
                Text(
                  l10n.homeAddressLocation,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DarkTeal,
                  ),
                ),
              ],
            ),

            SizedBox(width: 10),

            Icon(Icons.location_on_outlined, color: DarkTeal, size: 26),
          ],
        ),

        SizedBox(height: 16),

        // search bar ui only "no search logic for now"
        TextField(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: l10n.homeSearchHint,
            hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            hintStyle: TextStyle(fontSize: 12, color: DimGray),
            prefixIcon: Icon(Icons.search_rounded, color: DarkTeal, size: 22),
            filled: true,
            fillColor: Cream,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: DimGray),
            ),
          ),
        ),
      ],
    );
  }
}
