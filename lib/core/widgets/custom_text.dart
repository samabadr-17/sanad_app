import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const AppText(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: (style ?? const TextStyle()).copyWith(
        shadows: const [
          Shadow(color: Color(0x99000000), offset: Offset(5, 5), blurRadius: 7),
        ],
      ),
    );
  }
}
