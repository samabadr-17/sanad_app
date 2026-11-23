
import 'package:flutter/material.dart';

import '../../data/model/order_model.dart';
import '../../../../../core/constants/colors.dart';

class OrderCards extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderCards({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {

    // Check if there are no orders
    if (orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'You have no orders yet',
            style: TextStyle(
              color: DimGray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // Display order cards
    return Column(
      children: orders.map((order) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: SeaShell,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Cream,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Cream,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status,
                      style: const TextStyle(
                        color: DarkTeal,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order.id,
                    style: const TextStyle(
                      color: DimGray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                order.notes,
                style: const TextStyle(
                  color: DarkTeal,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 7),

              // Text(
              //   order.details,
              //   style: const TextStyle(
              //     color: Boxshadowcolor,
              //     fontSize: 10,
              //   ),
              // ),

              // const SizedBox(height: 7),

              // Text(
              //   order.date,
              //   style: const TextStyle(
              //     color: DimGray,
              //     fontSize: 10,
              //   ),
              // ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
