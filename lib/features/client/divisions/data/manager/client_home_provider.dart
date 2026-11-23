import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sanad/features/client/client_home/data/model/provider_model.dart';
import 'package:sanad/features/client/client_home/data/model/service_model.dart';

class ClientHomeProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final List<ServiceModel> _services = [];
  final List<ProviderModel> _providers = [];

  ClientHomeProvider() {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await Future.wait([_loadServices(), _loadProviders()]);
  }

  Future<void> _loadServices() async {
    final rows = await _tryReadTables([
      'categories',
      'services',
      'service_categories',
    ]);
    if (rows.isEmpty) return;

    _services
      ..clear()
      ..addAll(
        rows
            .map((row) {
              final id = _readText(row, ['id', 'category_id', 'service_id']);
              final title = _readText(row, [
                'name',
                'title',
                'service_name',
                'category_name',
              ]);
              final iconKey = _readText(row, ['icon', 'icon_key', 'iconName']);
              return ServiceModel(
                id: id,
                title: title,
                icon: _serviceIcon(iconKey),
              );
            })
            .where((service) => service.title.isNotEmpty),
      );
    notifyListeners();
  }

  Future<void> _loadProviders() async {
    final rows = await _tryReadTables([
      'provider_profiles',
      'providers',
      'professionals',
      'technicians',
      'craftsmen',
    ], columns: 'id, category_id, name, rating, experience, price');

    _providers
      ..clear()
      ..addAll(
        rows
            .map((row) {
              return ProviderModel(
                id: _readText(row, ['id']),
                categoryId: _readText(row, ['category_id']),
                name: _readText(row, ['name']),
                rating: _readText(row, ['rating']),
                experience: _readText(row, ['experience']),
                price: _readInt(row['price']),
              );
            })
            .where((provider) => provider.name.isNotEmpty),
      );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _tryReadTables(
    List<String> tableNames, {
    String columns = '*',
  }) async {
    for (final tableName in tableNames) {
      try {
        final rows = await _supabase.from(tableName).select(columns).limit(30);
        if (rows.isNotEmpty) {
          return rows.map((row) => Map<String, dynamic>.from(row)).toList();
        }
      } catch (_) {
        continue;
      }
    }
    return [];
  }

  String _readText(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      final value = row[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  int _readInt(dynamic value) {
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _serviceIcon(String iconKey) {
    const icons = {
      'painting': 'assets/icons/paint-roller.svg',
      'paint': 'assets/icons/paint-roller.svg',
      'appliances': 'assets/icons/washing-machine.svg',
      'plumbing': 'assets/icons/hammer.svg',
      'carpentry': 'assets/icons/hammer.svg',
      'electric': 'assets/icons/plug-zap.svg',
      'electrical': 'assets/icons/plug-zap.svg',
      'car': 'assets/icons/car-front.svg',
    };
    final key = iconKey.toLowerCase();
    if (key.startsWith('assets/')) return key;
    return icons[key] ?? 'assets/icons/hammer.svg';
  }

  // storing id of selected servic
  String? _selectedServiceId;

  // getters to access private data "we can access the lists through provider"
  List<ServiceModel> get services => _services;
  List<ProviderModel> get providers => _providers;

  // function that is called when the client choose service where id of the selected dercive is recieeved
  void selectService(String serviceId) {
    _selectedServiceId = serviceId;
    // notify the ui that the selected service changed
    notifyListeners();
  }

  // getter return list of providers acc to selected service
  List<ProviderModel> get filteredProviders {
    // if no service is selected, display all providers
    if (_selectedServiceId == null) {
      return _providers;
    } else {
      // else return only providers related to the selected service
      return _providers.where((provider) {
        return provider.categoryId == _selectedServiceId;
      }).toList(); // convert it to list
    }
  }
}
