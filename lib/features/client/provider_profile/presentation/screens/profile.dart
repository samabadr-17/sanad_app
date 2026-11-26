import 'package:flutter/material.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/features/client/provider_profile/data/model/provider_profile.dart';
import 'package:sanad/features/client/tellusToFix/presentation/screens/tellUs.dart';

class Profile extends StatefulWidget {
  final String providerId;
  final String? selectedDivisionName;

  const Profile({
    super.key,
    required this.providerId,
    this.selectedDivisionName,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<ProviderProfile> _future;

  @override
  void initState() {
    super.initState();
    _future = ProviderProfile.fetch(widget.providerId);
  }

  void _retry() {
    setState(() => _future = ProviderProfile.fetch(widget.providerId));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Cream,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(Icons.arrow_back, color: DarkTeal),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ملف المتخصص',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: DarkTeal,
                      ),
                    ),
                  ],
                ),
              ),

              // Loading / error / data
              Expanded(
                child: FutureBuilder<ProviderProfile>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(color: DarkTeal),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'حصل خطأ في تحميل البيانات',
                              style: TextStyle(color: SplashText),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _retry,
                              child: const Text(
                                'حاول مرة تانية',
                                style: TextStyle(color: Rust),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _body(snapshot.data!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(ProviderProfile p) {
    final badge = [
      if (p.isVerified) 'هوية موثّقة',
      '${ar(p.experienceYears)} سنوات خبرة',
    ].join(' • ');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: DarkTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Champagane,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _initials(p.name),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: DarkTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: SeaShell,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'متخصص ${p.category}',
                        style: const TextStyle(fontSize: 14, color: StoneWhite),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Champagane,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: DarkTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(value: ar(p.completedVisits), label: 'زيارة مكتملة'),
                    _Stat(value: ar(p.experienceYears), label: 'سنوات الخبرة'),
                    _Stat(
                      value: ar(p.rating.toStringAsFixed(1)),
                      label: 'التقييم',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // About
                _SectionTitle('عن ${_firstName(p.name)}'),
                const SizedBox(height: 8),
                Text(
                  p.bio,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: SplashText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [_Chip('✓ ${p.category}')]),

                const SizedBox(height: 20),

                // Coverage card
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'منطقة التغطية والمواعيد',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: DarkTeal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p.city,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SplashText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Not in the database yet, so this stays fixed for now
                      const Text(
                        'السبت–الخميس • ١٠ صباحًا–٨ مساءً',
                        style: TextStyle(fontSize: 12, color: DimGray),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Visit fee card
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رسوم الزيارة: ${ar(p.price)} ج.م',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: DarkTeal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'تشخيص فقط. الإصلاح وقطع الغيار بعرض سعر منفصل.',
                        style: TextStyle(fontSize: 12, color: DimGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TellUs(
                      selectedDivisionName: widget.selectedDivisionName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Rust,
                foregroundColor: SeaShell,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'طلب زيارة من ${_firstName(p.name)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- helpers ----------

String ar(Object value) {
  const western = '0123456789';
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  var s = value.toString().replaceAll('.', '٫');
  for (var i = 0; i < 10; i++) {
    s = s.replaceAll(western[i], arabic[i]);
  }
  return s;
}

String _firstName(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  return parts.first;
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.first.isEmpty) return '؟';
  return parts.take(2).map((p) => p[0]).join(' ');
}

// ---------- small widgets ----------

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: DarkTeal,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: DimGray)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: DarkTeal,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: StoneWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: DarkTeal)),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SeaShell,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Beige),
      ),
      child: child,
    );
  }
}
