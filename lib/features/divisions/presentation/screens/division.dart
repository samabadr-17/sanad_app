import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';
import 'package:sanad/features/divisions/data/model/model.dart';
import 'package:sanad/features/divisions/presentation/widget/card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------- Screen ----------
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Category>> _load() async {
    final rows = await Supabase.instance.client
        .from('categories')
        .select()
        .order('id');
    return rows.map<Category>((r) => Category.fromMap(r)).toList();
  }

  void _retry() => setState(() => _future = _load());

  List<Category> _filter(List<Category> all) {
    final q = _query.trim();
    if (q.isEmpty) return all;
    return all
        .where((c) => c.title.contains(q) || c.subtitle.contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.arrow_forward, color: Cream, size: 22),
                const SizedBox(width: 12),
                AppText("all divisions"),
              ],
            ),
            const SizedBox(height: 6),

            AppText("6 works sanad one"),

            const SizedBox(height: 18),

            AppText("explore services"),

            const SizedBox(height: 10),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Cream,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'ابحث عن خدمة أو عطل',
                  hintStyle: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  suffixIcon: const Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Data from Supabase
            FutureBuilder<List<Category>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: Cream),
                    ),
                  );
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        AppText("error loading divisions"),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _retry,
                          child: AppText("try again")
                        ),
                      ],
                    ),
                  );
                }

                final items = _filter(snap.data ?? []);
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: AppText("no results")
                    ),
                  );
                }

                return Column(
                  children: items
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: CategoryCard(category: c, onTap: () {}),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
