import 'package:flutter/material.dart';

class TellUs extends StatelessWidget {
  final String? selectedDivisionName;

  const TellUs({super.key, this.selectedDivisionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("your in tell us screen"),
          Text("Selected division: ${selectedDivisionName ?? ''}"),
        ],
      ),
    );
  }
}