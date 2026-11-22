import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/client_request.dart';

class ClientRequestsRepository {
  final SupabaseClient _supabase;

  ClientRequestsRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<List<ClientRequest>> loadRequests(String customerId) async {
    final rows = await _supabase
        .from('orders')
        .select('*, category:categories(name)')
        .eq('user_id', customerId)
        .order('created_at', ascending: false);

    return rows
        .map((row) => ClientRequest.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }
}
