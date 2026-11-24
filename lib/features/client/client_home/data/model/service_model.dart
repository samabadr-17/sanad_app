import 'package:sanad/features/client/divisions/data/model/model.dart';

class ServiceModel {
  final String id;
  final String title;
  final String icon;
  final String iconKey;
  final List<DivisionModel> divisionsArr;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.icon,
    this.iconKey = '',
    this.divisionsArr = const [],
  });
}
