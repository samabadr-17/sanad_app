import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderProfile {
  final String id;
  final String name;
  final String bio;
  final int experienceYears;
  final double rating;
  final bool isVerified;
  final String price;
  final String category;
  final String city;
  final int completedVisits;

  const ProviderProfile({
    required this.id,
    required this.name,
    required this.bio,
    required this.experienceYears,
    required this.rating,
    required this.isVerified,
    required this.price,
    required this.category,
    required this.city,
    required this.completedVisits,
  });

  static Future<ProviderProfile> fetch(String providerId) async {
    final db = Supabase.instance.client;

    // 1) The provider + category name + city name, in ONE request
    final row = await db
        .from('providers')
        .select(
          'id, name, bio, experience_years, rating, is_verified, price, '
          'categories(name), cities(name)',
        )
        .eq('id', providerId)
        .single();

    // 2) How many finished jobs this provider has
    final completed = await db
        .from('orders')
        .count(CountOption.exact)
        .eq('provider_id', providerId)
        .eq('status', 'completed');

    return ProviderProfile(
      id: row['id'] as String,
      name: (row['name'] as String?) ?? '',
      bio: (row['bio'] as String?) ?? '',
      experienceYears: (row['experience_years'] as int?) ?? 0,
      rating: ((row['rating'] as num?) ?? 0).toDouble(),
      isVerified: (row['is_verified'] as bool?) ?? false,
      price: (row['price'] ?? '').toString(),
      category: (row['categories'] as Map?)?['name'] as String? ?? '',
      city: (row['cities'] as Map?)?['name'] as String? ?? '',
      completedVisits: completed,
    );
  }
}