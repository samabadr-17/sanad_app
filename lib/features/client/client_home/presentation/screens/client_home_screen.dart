import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanad/features/client/client_home/presentation/manager/client_home_provider.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/home_header.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/order_card.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/provider_card.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/service_card.dart';
import 'package:sanad/l10n/app_localizations.dart';

import '../../../../../core/constants/colors.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get data from the clienthomeprovider
    final homeProvider = context.watch<ClientHomeProvider>();
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                              l10n.homeBannerEyebrow,
                              style: TextStyle(color: SeaShell, fontSize: 14),
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
                              l10n.homeBannerTitle,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: SeaShell,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              l10n.homeBannerDescription,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: SeaShell, fontSize: 10),
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
                            l10n.homeRequestServiceButton,
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
                    Text(
                      l10n.homeServicePrompt,
                      style: TextStyle(
                        color: Rust,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.allServices,
                      style: TextStyle(color: Rust, fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                ServiceCards(
                  services: homeProvider.services,
                  onServiceTap: (serviceId) {
                    // pass service id that will be chosen in the next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Placeholder(
                          // to the service details page
                          //serviceId: serviceId  parameter in the future for the next page
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),

                Row(
                  children: [
                    Text(
                      l10n.currentOrdersSection,
                      style: TextStyle(
                        color: Rust,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.trackRequest,
                      style: TextStyle(color: Rust, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (homeProvider.isLoadingOrders)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Rust),
                    ),
                  )
                else if (homeProvider.ordersError != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          l10n.ordersLoadError,
                          style: const TextStyle(color: DimGray),
                        ),
                        TextButton(
                          onPressed: homeProvider.loadHomeData,
                          child: Text(l10n.retryButton),
                        ),
                      ],
                    ),
                  )
                else
                  OrderCards(orders: homeProvider.orders),
                const SizedBox(height: 22),

                Row(
                  children: [
                    Text(
                      l10n.homeRecommendedProviders,
                      style: TextStyle(
                        color: Rust,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.viewAll,
                      style: TextStyle(color: Rust, fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                if (homeProvider.isLoadingProviders)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Rust),
                    ),
                  )
                else if (homeProvider.providersError != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          isArabic
                              ? 'تعذر تحميل مقدمي الخدمة'
                              : 'Could not load providers.',
                          style: const TextStyle(color: DimGray),
                        ),
                        TextButton(
                          onPressed: homeProvider.loadHomeData,
                          child: Text(l10n.retryButton),
                        ),
                      ],
                    ),
                  )
                else if (homeProvider.providers.isEmpty)
                  Center(
                    child: Text(
                      isArabic
                          ? 'لا يوجد مقدمو خدمة متاحون حاليًا'
                          : 'No providers are available right now.',
                      style: const TextStyle(color: DimGray),
                    ),
                  )
                else
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
