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
  bool _isLoadingOrders = false;
  Object? _ordersError;
  bool _isLoadingProviders = false;
  Object? _providersError;

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
      final rows = await _supabase
          .from('orders')
          .select('*, category:categories(name)')
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      _orders
        ..clear()
        ..addAll(
          rows
              .map((value) {
                final row = Map<String, dynamic>.from(value);
                final notes = _readText(row, ['notes', 'description']);
                final category = row['category'];
                final categoryName = category is Map
                    ? _readText(Map<String, dynamic>.from(category), ['name'])
                    : '';
                var title = _readText(row, [
                  'service_type',
                  'service_name',
                  'category_name',
                  'title',
                ]);
                if (title.isEmpty) title = categoryName;
                if (title.isEmpty) title = notes;
                final displayNotes = notes.isEmpty ? title : notes;
                final status = _readText(row, [
                  'status',
                  'order_status',
                  'request_status',
                ]);
                final id = _readText(row, [
                  'id',
                  'order_id',
                  'request_id',
                  'booking_id',
                ]);

                return OrderModel(
                  id: id,
                  title: title,
                  status: status,
                  notes: displayNotes,
                );
              })
              .where((order) => order.title.isNotEmpty),
        );
    } catch (error) {
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
          .select('id, category_id, name, rating, experience, price')
          .limit(30);

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
                  experience: _readText(providerRow, ['experience']),
                  price: _readInt(providerRow['price']),
                );
              })
              .where((provider) => provider.name.isNotEmpty),
        );
    } catch (error) {
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
  List<OrderModel> get orders => _orders;
  List<ProviderModel> get providers => _providers;
  bool get isLoadingOrders => _isLoadingOrders;
  Object? get ordersError => _ordersError;
  bool get isLoadingProviders => _isLoadingProviders;
  Object? get providersError => _providersError;

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
