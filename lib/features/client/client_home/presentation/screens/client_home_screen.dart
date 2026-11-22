import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanad/features/client/client_home/presentation/manager/client_home_provider.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/home_header.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/order_card.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/provider_card.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/service_card.dart';
import '../../../../../core/constants/colors.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get data from the clienthomeprovider
    final homeProvider = context.watch<ClientHomeProvider>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Cream,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(),
                SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: DarkTeal,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'سند اهل الصنعة جمبك',
                              style: TextStyle(
                                color: SeaShell,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.home_repair_service_outlined,
                              color: SeaShell,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Text(
                              'كل عطل، وله أهل صنعة',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: SeaShell,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'متخصصين موثوقين لكل خدماتك المنزلية',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: SeaShell,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 13),
                      SizedBox(
                        height: 43,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Rust,
                            foregroundColor: SeaShell,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Text(
                            'اطلب خدمة دلوقتي',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    const Text(
                      'محتاج إيه النهارده؟',
                      style: TextStyle(
                        color: Rust,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'كل الخدمات',
                      style: TextStyle(
                        color: Rust,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                ServiceCards(
                  services: homeProvider.services,
                  onServiceTap: (serviceId) { // pass service id that will be chosen in the next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Placeholder( // to the service details page
                        //serviceId: serviceId  parameter in the future for the next page
                      )), 
                    );
                  },
                ),
                const SizedBox(height: 22),

                Row(
                  children: [
                    const Text(
                      'طلباتك الحالي',
                      style: TextStyle(
                        color: Rust,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'متابعة الطلب',
                      style: TextStyle(
                        color: Rust,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OrderCards(orders: homeProvider.orders),
                const SizedBox(height: 22),

                Row(
                  children: [
                    const Text(
                      'أفضل خبرة',
                      style: TextStyle(
                        color: Rust,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'عرض الكل',
                      style: TextStyle(
                        color: Rust,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                ProviderCards(providers: homeProvider.providers),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
