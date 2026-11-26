import 'package:flutter/material.dart';
import 'package:sanad/features/client/provider_profile/presentation/screens/profile.dart';

import '../../data/model/provider_model.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../l10n/app_localizations.dart';
// Adjust this path to wherever your Profile file lives

class ProviderCards extends StatelessWidget {
  final List<ProviderModel> providers;
  final String? selectedDivisionName;

  const ProviderCards({
    super.key,
    required this.providers,
    this.selectedDivisionName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: providers.map((provider) {
        final years = int.tryParse(provider.experience);
        final experience = years == null
            ? provider.experience
            : l10n.providerExperience(years);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Profile(
                  providerId: provider.id,
                  selectedDivisionName: selectedDivisionName,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: SeaShell,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Cream),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Cream,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: DarkTeal,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Text(
                              provider.name,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: DarkTeal,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '★ ${provider.rating.isEmpty ? '—' : provider.rating}',
                            style: const TextStyle(
                              color: DarkTeal,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (experience.isNotEmpty)
                            _ProviderInfoChip(label: experience),
                          _ProviderInfoChip(
                            label: l10n.providerVisitPrice(provider.price),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ProviderInfoChip extends StatelessWidget {
  final String label;

  const _ProviderInfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Cream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: DarkTeal,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}