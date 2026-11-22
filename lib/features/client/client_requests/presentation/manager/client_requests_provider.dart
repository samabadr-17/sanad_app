import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/client_request.dart';
import '../../data/repo/client_requests_repository.dart';

class ClientRequestsProvider extends ChangeNotifier {
  final ClientRequestsRepository _repository;

  ClientRequestsProvider({ClientRequestsRepository? repository})
    : _repository = repository ?? ClientRequestsRepository();

  List<ClientRequest> _requests = [];
  bool isLoading = false;
  bool requiresLogin = false;
  Object? error;

  List<ClientRequest> get requests => List.unmodifiable(_requests);

  Future<void> loadRequests() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      requiresLogin = true;
      isLoading = false;
      error = null;
      _requests = [];
      notifyListeners();
      return;
    }

    requiresLogin = false;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _requests = await _repository.loadRequests(userId);
    } catch (exception) {
      error = exception;
      _requests = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
