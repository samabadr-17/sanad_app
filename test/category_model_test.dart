import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/client/divisions/data/model/model.dart';

void main() {
  test(
    'parses division labels and icon keys while ignoring invalid entries',
    () {
      final category = Category.fromMap({
        'id': 1,
        'name': 'Plumbing',
        'divisions': [
          {'name': 'AC installation', 'iconKey': 'ac_unit'},
          {'name': 'maintenance', 'iconKey': 'build'},
          {'name': 'gas refilling', 'iconKey': 'propane_tank'},
          {'name': 'filter cleaning', 'iconKey': 'cleaning_services'},
          null,
          {'name': '  ', 'iconKey': 'build'},
        ],
        'icon': 'plumbing',
      });

      expect(category.divisions.map((division) => division.name), [
        'AC installation',
        'maintenance',
        'gas refilling',
        'filter cleaning',
      ]);
      expect(category.divisions.map((division) => division.iconDataFor('ac')), [
        Icons.ac_unit,
        Icons.build,
        Icons.propane_tank,
        Icons.cleaning_services,
      ]);
    },
  );

  test('decodes stringified division objects', () {
    final division = DivisionModel.fromValue(
      '{"name":"AC installation","iconKey":"ac_unit"}',
    );

    expect(division.name, 'AC installation');
    expect(division.iconDataFor('ac'), Icons.ac_unit);
  });

  test('handles a null category name without a string cast error', () {
    final category = Category.fromMap({
      'id': 1,
      'name': null,
      'icon': null,
      'divisions': const [],
    });

    expect(category.title, isEmpty);
    expect(category.iconKey, isEmpty);
  });
}
