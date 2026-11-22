import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/client/client_requests/data/model/client_request.dart';

void main() {
  test('maps order id, related category, status and request details', () {
    final request = ClientRequest.fromMap({
      'id': 42,
      'status': 'pending',
      'address': 'Nasr City',
      'scheduled_at': '2026-11-25T10:00:00Z',
      'created_at': '2026-11-20T08:00:00Z',
      'category': {'name': 'Plumbing'},
    });

    expect(request.id, '42');
    expect(request.serviceType, 'Plumbing');
    expect(request.status, 'pending');
    expect(request.address, 'Nasr City');
    expect(request.scheduledAt, DateTime.parse('2026-11-25T10:00:00Z'));
    expect(request.createdAt, DateTime.parse('2026-11-20T08:00:00Z'));
  });
}
