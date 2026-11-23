// Database key -> Flutter icon
import 'package:flutter/material.dart';

const kIcons = <String, IconData>{
  'plumbing': Icons.plumbing_outlined,
  'appliances': Icons.local_laundry_service_outlined,
  'painting': Icons.format_paint_outlined,
  'carpentry': Icons.hardware_outlined,
  'electric': Icons.electrical_services_outlined,
  'ac': Icons.ac_unit_outlined,
};


// ---------- Model ----------
class Category {
  final int id;
  final String title;
  final List<String> divisions;
  final String iconKey;

  const Category({
    required this.id,
    required this.title,
    required this.divisions,
    required this.iconKey,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'] as int,
        title: map['name'] as String,
        divisions: List<String>.from(map['divisions'] ?? []),
        iconKey: (map['icon'] ?? '') as String,
      );

  String get subtitle => divisions.join('، ');
  IconData get icon => kIcons[iconKey] ?? Icons.build_outlined;
}
