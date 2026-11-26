import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';
import 'package:sanad/features/client/client_home/data/model/service_model.dart';
import 'package:sanad/features/client/client_home/presentation/manager/client_home_provider.dart';
import 'package:sanad/features/client/divisions/data/model/model.dart';
import 'package:sanad/features/client/divisions/presentation/screens/category_details_screen.dart';

// ---------- Screen ----------
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _query = '';

  List<ServiceModel> _filter(List<ServiceModel> all) {
    final q = _query.trim();
    if (q.isEmpty) return all;
    return all
        .where(
          (service) => service.title.toLowerCase().contains(q.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientHomeProvider>();
    final items = _filter(provider.services);

    return Scaffold(
      backgroundColor: Cream,
      body: SafeArea(
        child: RefreshIndicator(
          color: Rust,
          onRefresh: provider.loadHomeData,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_forward, color: DarkTeal, size: 22),
                    const SizedBox(width: 12),
                    AppText(
                      'جميع الأقسام',
                      style: GoogleFonts.cairo(
                        color: DarkTeal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              AppText(
                '${provider.services.length} أقسام — كل صنعة لها سند',
                style: GoogleFonts.cairo(color: DimGray, fontSize: 13),
              ),
              const SizedBox(height: 18),
              AppText(
                'استكشف الخدمات',
                style: GoogleFonts.cairo(
                  color: DarkTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: SeaShell,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DarkTeal.withOpacity(0.15)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                  cursorColor: Rust,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: DarkTeal,
                    hintText: 'ابحث عن خدمة أو عطل',
                    hintStyle: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                    suffixIcon: const Icon(Icons.search, color: Colors.white),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (provider.services.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(child: CircularProgressIndicator(color: Rust)),
                )
              else if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: AppText(
                      'لا توجد نتائج',
                      style: GoogleFonts.cairo(color: DimGray),
                    ),
                  ),
                )
              else
                Column(
                  children: items
                      .map(
                        (service) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CategoryTile(
                            service: service,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryDetailsScreen(
                                    categoryId: service.id,
                                    categoryTitle: service.title,
                                    categoryIconKey: categoryIconGroup(
                                      service.iconKey,
                                      title: service.title,
                                    ),
                                    categoryIcon: categoryIconFor(
                                      service.iconKey,
                                      service.title,
                                    ),
                                    divisionsArr: service.divisionsArr,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _CategoryTile({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: StoneWhite,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: DarkTeal.withOpacity(0.12)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: DarkTeal.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  categoryIconFor(service.iconKey, service.title),
                  color: DarkTeal,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  service.title,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    color: DarkTeal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_left, color: Rust, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

IconData categoryIconFor(String iconKey, String title) {
  final group = categoryIconGroup(iconKey, title: title);
  return kIcons[group] ?? Icons.build_outlined;
}
