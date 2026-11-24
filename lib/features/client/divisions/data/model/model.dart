// Database key -> Flutter icon
import 'dart:convert';

import 'package:flutter/material.dart';

const kIcons = <String, IconData>{
  'plumbing': Icons.plumbing_outlined,
  'appliances': Icons.local_laundry_service_outlined,
  'painting': Icons.format_paint_outlined,
  'carpentry': Icons.hardware_outlined,
  'electric': Icons.electrical_services_outlined,
  'ac': Icons.ac_unit_outlined,
};

const kPlumbingDivisionIcons = <String, IconData>{
  'pipe_repair': Icons.plumbing_outlined,
  'drain_cleaning': Icons.cleaning_services,
  'water_leak': Icons.water_drop_outlined,
  'build': Icons.build,
};

const kAppliancesDivisionIcons = <String, IconData>{
  'washing_machine': Icons.local_laundry_service_outlined,
  'refrigerator': Icons.kitchen,
  'microwave': Icons.microwave,
  'build': Icons.build,
};

const kPaintingDivisionIcons = <String, IconData>{
  'interior_painting': Icons.format_paint_outlined,
  'exterior_painting': Icons.home_outlined,
  'wall_painting': Icons.format_paint_outlined,
  'build': Icons.build,
};

const kCarpentryDivisionIcons = <String, IconData>{
  'furniture_repair': Icons.hardware_outlined,
  'door_repair': Icons.home_repair_service_outlined,
  'woodwork': Icons.hardware_outlined,
  'build': Icons.build,
};

const kElectricDivisionIcons = <String, IconData>{
  'wiring': Icons.electrical_services_outlined,
  'lighting': Icons.lightbulb_outline,
  'outlet_repair': Icons.electrical_services_outlined,
  'build': Icons.build,
};

const kAcDivisionIcons = <String, IconData>{
  'ac_unit': Icons.ac_unit,
  'build': Icons.build,
  'propane_tank': Icons.propane_tank,
  'cleaning_services': Icons.cleaning_services,
};

const kDivisionIconsByCategory = <String, Map<String, IconData>>{
  'plumbing': kPlumbingDivisionIcons,
  'appliances': kAppliancesDivisionIcons,
  'painting': kPaintingDivisionIcons,
  'carpentry': kCarpentryDivisionIcons,
  'electric': kElectricDivisionIcons,
  'ac': kAcDivisionIcons,
};

String categoryIconGroup(String iconKey, {String title = ''}) {
  for (final value in [iconKey, title]) {
    final normalized = value
        .trim()
        .toLowerCase()
        .split('/')
        .last
        .replaceFirst(RegExp(r'\.svg$'), '')
        .replaceAll('-', '_')
        .replaceAll(RegExp(r'\s+'), '_');
    if (kDivisionIconsByCategory.containsKey(normalized)) return normalized;

    switch (normalized) {
      case 'electrical':
      case 'electricity':
      case 'plug_zap':
      case 'كهرباء':
        return 'electric';
      case 'air_conditioning':
      case 'air_conditioner':
      case 'snowflake':
      case 'heater':
      case 'تكييف':
      case 'مكيفات':
        return 'ac';
      case 'paint':
      case 'paint_roller':
      case 'نقاشة':
      case 'دهان':
        return 'painting';
      case 'washing_machine':
      case 'refrigerator':
      case 'microwave':
      case 'أجهزة':
        return 'appliances';
      case 'hammer':
      case 'نجارة':
        return 'carpentry';
      case 'سباكة':
        return 'plumbing';
    }

    if (normalized.contains('كهرب')) return 'electric';
    if (normalized.contains('تكييف') || normalized.contains('مكيف')) {
      return 'ac';
    }
    if (normalized.contains('نقاش') || normalized.contains('دهان')) {
      return 'painting';
    }
    if (normalized.contains('جهاز') || normalized.contains('أجهزة')) {
      return 'appliances';
    }
    if (normalized.contains('نجار')) return 'carpentry';
    if (normalized.contains('سباك')) return 'plumbing';
  }
  return '';
}

class DivisionModel {
  final String name;
  final String iconKey;
  final String divisionKey;

  const DivisionModel({
    required this.name,
    required this.iconKey,
    this.divisionKey = '',
  });

  factory DivisionModel.fromMap(Map<String, dynamic> map) {
    final name = map['name'];
    final iconKey = map['iconKey'] ?? map['icon_key'];
    final divisionKey = map['divisionKey'] ?? map['division_key'];
    final divisionName = name is String ? name.trim() : '';
    final key = divisionKey is String && divisionKey.trim().isNotEmpty
        ? divisionKey.trim().toLowerCase()
        : _divisionKeyFromName(divisionName);

    return DivisionModel(
      name: divisionName,
      iconKey: iconKey is String ? iconKey.trim().toLowerCase() : '',
      divisionKey: key,
    );
  }

  factory DivisionModel.fromValue(dynamic value) {
    if (value is Map) {
      return DivisionModel.fromMap(Map<String, dynamic>.from(value));
    }

    if (value is String) {
      final text = value.trim();
      if (text.startsWith('{') && text.endsWith('}')) {
        final decoded = jsonDecode(text);
        if (decoded is Map) {
          return DivisionModel.fromMap(Map<String, dynamic>.from(decoded));
        }
        return const DivisionModel(name: '', iconKey: '');
      }
      return DivisionModel(
        name: text,
        iconKey: '',
        divisionKey: _divisionKeyFromName(text),
      );
    }

    return const DivisionModel(name: '', iconKey: '');
  }

  IconData iconDataFor(String categoryKey) {
    final category = categoryIconGroup(categoryKey);
    return kDivisionIconsByCategory[category]?[iconKey] ??
        kIcons[category] ??
        Icons.build_outlined;
  }
}

String _divisionKeyFromName(String name) =>
    name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');

// ---------- Model ----------
class Category {
  final int id;
  final String title;
  final List<DivisionModel> divisions;
  final String iconKey;

  const Category({
    required this.id,
    required this.title,
    required this.divisions,
    required this.iconKey,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int,
    title: map['name'] is String ? (map['name'] as String).trim() : '',
    divisions: _readDivisions(map['divisions']),
    iconKey: map['icon'] is String ? (map['icon'] as String).trim() : '',
  );

  String get subtitle => divisions.map((division) => division.name).join('، ');
  IconData get icon => kIcons[iconKey] ?? Icons.build_outlined;
}

List<DivisionModel> _readDivisions(dynamic value) {
  if (value is! List) return const [];
  return value
      .map(DivisionModel.fromValue)
      .where((division) => division.name.isNotEmpty)
      .toList();
}
