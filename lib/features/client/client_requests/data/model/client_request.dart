class ClientRequest {
  final String id;
  final String serviceType;
  final String status;
  final String? address;
  final DateTime? scheduledAt;
  final DateTime? createdAt;
  final Map<String, dynamic> data;

  const ClientRequest({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.data,
    this.address,
    this.scheduledAt,
    this.createdAt,
  });

  factory ClientRequest.fromMap(Map<String, dynamic> row) {
    final category = row['category'];
    final categoryName = category is Map<String, dynamic>
        ? category['name']?.toString()
        : null;

    return ClientRequest(
      id: row['id']?.toString() ?? '',
      serviceType:
          _firstText(row, [
            'service_type',
            'service_name',
            'category_name',
            'title',
          ]) ??
          categoryName ??
          '',
      status: row['status']?.toString() ?? '',
      address: _firstText(row, ['address', 'location']),
      scheduledAt: _firstDate(row, ['scheduled_at', 'appointment_at']),
      createdAt: _firstDate(row, ['created_at']),
      data: row,
    );
  }

  static String? _firstText(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      final value = row[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static DateTime? _firstDate(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      final value = row[key];
      if (value != null) {
        final date = DateTime.tryParse(value.toString());
        if (date != null) return date;
      }
    }
    return null;
  }
}
