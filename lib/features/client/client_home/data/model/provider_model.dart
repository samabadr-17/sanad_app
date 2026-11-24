class ProviderModel {
  final String id;
  final String categoryId;
  final String divisionKey;
  final String name;
  final String rating;
  final String experience;
  final int price;

  const ProviderModel({
    required this.id,
    required this.categoryId,
    this.divisionKey = '',
    required this.name,
    required this.rating,
    required this.experience,
    required this.price,
  });
}
