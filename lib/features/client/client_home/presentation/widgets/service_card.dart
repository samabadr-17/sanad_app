import 'package:flutter/material.dart';

import '../../data/model/service_model.dart';
import '../../../../../core/constants/colors.dart';

class ServiceCards extends StatelessWidget {
  // list of services displayed in the gridview
  final List<ServiceModel> services;
  // function called when the user choose service
  final Function(String) onServiceTap; // this way will make us to send the id , voidcallback will not allow us to do this

  const ServiceCards({
    super.key,
    required this.services,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, //take only the height it needs "not entire height of the screen"
      // number of service cards
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards in each row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      // build each card using its index
      itemBuilder: (context, index) {
        final service = services[index];
        final icon = _serviceIcon(service.icon, service.title);
        return GestureDetector(
          onTap: () {
            onServiceTap(
              service.id,
            ); // send the id of selected service to the provider
          },
          child: Container(
            decoration: BoxDecoration(
              color: SeaShell,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Cream),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: DimGray, size: 32),
                SizedBox(height: 8),
                Text(
                  service.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DarkTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _serviceIcon(String icon, String title) {
    final value = '${icon.toLowerCase()} ${title.toLowerCase()}';
    if (value.contains('paint') ||
        value.contains('دهان') ||
        value.contains('نقاش') ||
        value.contains('صباغ')) {
      return Icons.format_paint_outlined;
    }
    if (value.contains('washing') ||
        value.contains('appliance') ||
        value.contains('غسالة') ||
        value.contains('اجهزة') ||
        value.contains('أجهزة')) {
      return Icons.local_laundry_service_outlined;
    }
    if (value.contains('plumb') ||
        value.contains('pipe') ||
        value.contains('سباك') ||
        value.contains('سباكه') ||
        value.contains('سباكة')) {
      return Icons.plumbing_outlined;
    }
    if (value.contains('hammer') ||
        value.contains('carpent') ||
        value.contains('نجار') ||
        value.contains('نجارة')) {
      return Icons.hardware_outlined;
    }
    if (value.contains('plug') ||
        value.contains('electric') ||
        value.contains('كهرباء') ||
        value.contains('كهربائ')) {
      return Icons.electrical_services_outlined;
    }
    if (value.contains('car') ||
        value.contains('مركب') ||
        value.contains('سيارة') ||
        value.contains('عربيه') ||
        value.contains('عربية')) {
      return Icons.car_repair_outlined;
    }
    if (value.contains('ac') ||
        value.contains('air') ||
        value.contains('تكييف') ||
        value.contains('تبرد')) {
      return Icons.ac_unit_outlined;
    }
    if (value.contains('plumbing') ||
        value.contains('heater') ||
        value.contains('سخان')) {
      return Icons.thermostat_outlined;
    }
    return Icons.build_outlined;
  }
}
