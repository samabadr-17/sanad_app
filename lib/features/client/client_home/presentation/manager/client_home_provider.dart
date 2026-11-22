import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/order_model.dart';
import '../../data/model/provider_model.dart';
import '../../data/model/service_model.dart';

class ClientHomeProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final List<ServiceModel> _services = [];
  final List<OrderModel> _orders = [];
  final List<ProviderModel> _providers = [];

  ClientHomeProvider() {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await Future.wait([_loadServices(), _loadOrders(), _loadProviders()]);
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

  Future<void> _loadOrders() async {
    final rows = await _tryReadTables([
      'orders',
      'service_requests',
      'requests',
      'bookings',
      'appointments',
    ]);
    if (rows.isEmpty) return;

    final currentUserId = _supabase.auth.currentUser?.id;
    final filteredRows = rows.where((row) {
      if (currentUserId == null) return false;
      for (final key in [
        'client_id',
        'user_id',
        'customer_id',
        'requested_by',
      ]) {
        if (row.containsKey(key) && row[key] != null) {
          return row[key].toString() == currentUserId;
        }
      }
      return true;
    }).toList();

    _orders
      ..clear()
      ..addAll(
        filteredRows
            .map((row) {
              final id = _readText(row, [
                'id',
                'order_id',
                'request_id',
                'booking_id',
              ]);
              final title = _readText(row, [
                'title',
                'name',
                'service_name',
                'category_name',
                'description',
              ]);
              final status = _readText(row, [
                'status',
                'order_status',
                'request_status',
              ]);
              final date = _readText(row, [
                'scheduled_at',
                'appointment_at',
                'date',
                'visit_date',
                'created_at',
              ]);
              final providerName = _readText(row, [
                'provider_name',
                'technician_name',
                'craftsman_name',
              ]);
              final location = _readText(row, [
                'address',
                'location',
                'city',
                'area',
              ]);
              final details = [
                if (providerName.isNotEmpty) providerName,
                if (location.isNotEmpty) location,
              ].join(' • ');

              return OrderModel(
                id: id,
                title: title,
                status: status,
                date: date,
                details: details,
              );
            })
            .where((order) => order.title.isNotEmpty),
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
      'users',
    ]);
    if (rows.isEmpty) return;

    final providerRows = rows.where((row) {
      for (final key in ['user_type_id', 'role_id', 'role', 'account_type']) {
        if (row.containsKey(key)) {
          final value = row[key].toString().toLowerCase();
          if (value == 'provider' ||
              value == 'technician' ||
              value == 'craftsman' ||
              value == '2') {
            return true;
          }
        }
      }
      return !row.containsKey('user_type_id') &&
          !row.containsKey('role_id') &&
          !row.containsKey('role') &&
          !row.containsKey('account_type');
    }).toList();

    _providers
      ..clear()
      ..addAll(
        providerRows
            .map((row) {
              final name = _readText(row, [
                'name',
                'full_name',
                'display_name',
                'provider_name',
              ]);
              final ratingValue = _readText(row, ['rating', 'average_rating']);
              final reviewCount = _readText(row, [
                'reviews_count',
                'rating_count',
              ]);
              final rating = reviewCount.isNotEmpty
                  ? '$ratingValue ($reviewCount)'
                  : ratingValue;
              final experienceValue = _readText(row, [
                'experience',
                'experience_years',
                'years_of_experience',
              ]);
              final availability = _readText(row, [
                'availability',
                'availablity',
                'availability_status',
              ]);
              final priceValue = _readText(row, [
                'visit_price',
                'price',
                'hourly_rate',
                'starting_price',
              ]);

              return ProviderModel(
                id: _readText(row, ['id', 'provider_id', 'user_id']),
                name: name,
                initial: _initials(name),
                speciality: _readText(row, [
                  'speciality',
                  'specialty',
                  'profession',
                  'category_name',
                ]),
                rating: rating,
                experience: experienceValue,
                availablity: availability,
                price: int.tryParse(priceValue) ?? 0,
                serviceId: _readText(row, [
                  'service_id',
                  'category_id',
                  'category',
                ]),
              );
            })
            .where((provider) => provider.name.isNotEmpty),
      );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _tryReadTables(
    List<String> tableNames,
  ) async {
    for (final tableName in tableNames) {
      try {
        final rows = await _supabase.from(tableName).select().limit(30);
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

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.isEmpty ? '' : parts.first.substring(0, 1);
    }
    final firstInitial = parts.first.isEmpty ? '' : parts.first.substring(0, 1);
    final secondInitial = parts[1].isEmpty ? '' : parts[1].substring(0, 1);
    return '$firstInitial $secondInitial';
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
  List<OrderModel> get orders => _orders;
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
        return provider.serviceId == _selectedServiceId;
      }).toList(); // convert it to list
    }
  }
}
