import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';
import 'package:sanad/features/client/client_home/presentation/manager/client_home_provider.dart';
import 'package:sanad/features/client/client_home/presentation/widgets/provider_card.dart';
import 'package:sanad/features/client/divisions/data/model/model.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final String categoryIconKey;
  final IconData categoryIcon;
  final List<DivisionModel> divisionsArr;

  const CategoryDetailsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryIconKey,
    required this.categoryIcon,
    required this.divisionsArr,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  String? _selectedDivisionKey;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientHomeProvider>();
    final categoryProviders = _selectedDivisionKey == null
        ? provider.providersForCategory(widget.categoryId)
        : provider.providersForDivision(
            widget.categoryId,
            _selectedDivisionKey!,
          );

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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_forward, color: DarkTeal),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.categoryTitle,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          color: DarkTeal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(widget.categoryIcon, color: Rust, size: 28),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              AppText("تختار المشكله و نوصلك للمتخصص المناسب"),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: DarkTeal,
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
                child: Column(
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: DarkTeal.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.abc,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      'خدمه راقيه',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      'شغل احترافي علي ايد اهل الخبره',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _SectionTitle(title: 'ايه اللي محتاج صيانه'),
              const SizedBox(height: 10),
              if (widget.divisionsArr.isEmpty)
                Text(
                  'لا توجد أقسام فرعية متاحة',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(color: DimGray, fontSize: 13),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.divisionsArr.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final division = widget.divisionsArr[index];
                    final isSelected =
                        division.divisionKey == _selectedDivisionKey;
                    return Material(
                      color: isSelected ? Cream : SeaShell,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _selectedDivisionKey = isSelected
                                ? null
                                : division.divisionKey;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Rust
                                  : DarkTeal.withOpacity(0.12),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                division.iconDataFor(widget.categoryIconKey),
                                color: DarkTeal,
                                size: 26,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  division.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    color: DarkTeal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
              _SectionTitle(title: 'متخصصون في منطقتك'),
              const SizedBox(height: 10),
              if (provider.isLoadingProviders)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Rust),
                  ),
                )
              else if (provider.providersError != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        'تعذر تحميل مقدمي الخدمة',
                        style: GoogleFonts.cairo(color: DimGray),
                      ),
                      TextButton(
                        onPressed: provider.loadHomeData,
                        child: Text(
                          'إعادة المحاولة',
                          style: GoogleFonts.cairo(color: Rust),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_selectedDivisionKey != null &&
                  !provider.supportsDivisionFiltering)
                Text(
                  'تصفية مقدمي الخدمة حسب القسم الفرعي تتطلب إضافة division_key لجدول providers',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(color: DimGray, fontSize: 13),
                )
              else if (categoryProviders.isEmpty)
                Text(
                  'لا يوجد مقدمو خدمة لهذا القسم حاليًا',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(color: DimGray, fontSize: 13),
                )
              else
                ProviderCards(providers: categoryProviders),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: GoogleFonts.cairo(
        color: Rust,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
