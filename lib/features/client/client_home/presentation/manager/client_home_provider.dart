import 'dart:async';

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
  late final StreamSubscription<AuthState> _authSubscription;
  bool _isLoadingOrders = false;
  Object? _ordersError;
  bool _isLoadingProviders = false;
  Object? _providersError;

  ClientHomeProvider() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.initialSession ||
          state.event == AuthChangeEvent.signedIn) {
        loadHomeData();
      } else if (state.event == AuthChangeEvent.signedOut) {
        _orders.clear();
        _isLoadingOrders = false;
        _ordersError = null;
        notifyListeners();
      }
    });
    loadHomeData();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> loadHomeData() async {
    // services first, because orders use them to find the category name
    await _loadServices();
    await Future.wait([_loadOrders(), _loadProviders()]);
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
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      _orders.clear();
      _isLoadingOrders = false;
      _ordersError = null;
      notifyListeners();
      return;
    }

    _isLoadingOrders = true;
    _ordersError = null;
    notifyListeners();
    try {
      // plain select, no join, so it doesn't depend on a foreign key
      final rows = await _supabase
          .from('orders')
          .select('id, category_id, notes, status, address')
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      debugPrint('orders fetched: ${rows.length}');

      _orders
        ..clear()
        ..addAll(
          rows.map((value) {
            final row = Map<String, dynamic>.from(value);
            final categoryId = _readText(row, ['category_id']);

            // find the service name using the category id
            var title = '';
            for (final service in _services) {
              if (service.id == categoryId) {
                title = service.title;
                break;
              }
            }
            if (title.isEmpty) title = 'Service request';

            final notes = _readText(row, ['notes']);

            return OrderModel(
              id: _readText(row, ['id']),
              title: title,
              status: _readText(row, ['status']),
              notes: notes.isEmpty ? title : notes,
            );
          }),
        );
    } catch (error) {
      debugPrint('orders error: $error');
      _orders.clear();
      _ordersError = error;
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  Future<void> _loadProviders() async {
    _isLoadingProviders = true;
    _providersError = null;
    notifyListeners();
    try {
      final rows = await _supabase
          .from('providers')
          .select('id, category_id, name, rating, experience_years, price')
          .limit(30);

      debugPrint('providers fetched: ${rows.length}');

      _providers
        ..clear()
        ..addAll(
          rows
              .map((row) {
                final providerRow = Map<String, dynamic>.from(row);
                return ProviderModel(
                  id: _readText(providerRow, ['id']),
                  categoryId: _readText(providerRow, ['category_id']),
                  name: _readText(providerRow, ['name']),
                  rating: _readText(providerRow, ['rating']),
                  experience: _readText(providerRow, ['experience_years']),
                  price: _readInt(providerRow['price']),
                );
              })
              .where((provider) => provider.name.isNotEmpty),
        );
    } catch (error) {
      debugPrint('providers error: $error');
      _providers.clear();
      _providersError = error;
    } finally {
      _isLoadingProviders = false;
      notifyListeners();
    }
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

  // price is "text" in the providers table, so parse it as a number first
  int _readInt(dynamic value) {
    if (value is num) return value.round();
    return num.tryParse(value?.toString() ?? '')?.round() ?? 0;
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

  // storing id of selected service
  String? _selectedServiceId;

  // getters to access private data
  List<ServiceModel> get services => _services;
  List<OrderModel> get orders => _orders;
  List<ProviderModel> get providers => _providers;
  bool get isLoadingOrders => _isLoadingOrders;
  Object? get ordersError => _ordersError;
  bool get isLoadingProviders => _isLoadingProviders;
  Object? get providersError => _providersError;

  // called when the client chooses a service
  void selectService(String serviceId) {
    _selectedServiceId = serviceId;
    notifyListeners();
  }

  // providers filtered by the selected service
  List<ProviderModel> get filteredProviders {
    if (_selectedServiceId == null) {
      return _providers;
    }
    return _providers.where((provider) {
      return provider.categoryId == _selectedServiceId;
    }).toList();
  }
}