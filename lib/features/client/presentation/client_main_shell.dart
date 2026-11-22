import 'package:flutter/material.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/features/divisions/presentation/screens/division.dart';
import 'package:sanad/features/client/client_home/presentation/screens/client_home_screen.dart';
import 'package:sanad/features/client/client_requests/presentation/screens/client_requests_screen.dart';
import 'package:sanad/l10n/app_localizations.dart';

class ClientMainShell extends StatefulWidget {
  const ClientMainShell({super.key});

  @override
  State<ClientMainShell> createState() => _ClientMainShellState();
}

class _ClientMainShellState extends State<ClientMainShell> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final pages = [
      _ClientPlaceholder(title: l10n.accountNavigation),
      ClientRequestsScreen(
        onBackToHome: () => setState(() => _currentIndex = 3),
      ),
      const CategoriesScreen(),
      const ClientHomeScreen(),
    ];
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Cream,
        body: IndexedStack(index: _currentIndex, children: pages),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: SeaShell,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 12,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 72,
              child: Row(
                children: [
                  _buildNavigationItem(
                    index: 0,
                    icon: Icons.person_outline,
                    label: l10n.accountNavigation,
                  ),
                  _buildNavigationItem(
                    index: 1,
                    icon: Icons.assignment_outlined,
                    label: l10n.myRequestsNavigation,
                  ),
                  _buildNavigationItem(
                    index: 2,
                    icon: Icons.grid_view_rounded,
                    label: l10n.categoriesNavigation,
                  ),
                  _buildNavigationItem(
                    index: 3,
                    icon: Icons.home_outlined,
                    label: l10n.homeNavigation,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = _currentIndex == index;
    final color = selected ? Rust : DarkTeal;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientPlaceholder extends StatelessWidget {
  final String title;

  const _ClientPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cream,
      body: SafeArea(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: DarkTeal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
