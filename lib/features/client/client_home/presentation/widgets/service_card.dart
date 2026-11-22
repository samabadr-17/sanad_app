
import 'package:flutter/material.dart';

import '../../data/model/service_model.dart';
import'../../../../../core/constants/colors.dart';

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
        return GestureDetector(
          onTap: (){
            onServiceTap(service.id); // send the id of selected service to the provider
          },
          child: Container(
            decoration: BoxDecoration(
              color: SeaShell,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Cream,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  service.icon,
                  color: DimGray,//const Color(0xFF57958A)
                ),
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
}
