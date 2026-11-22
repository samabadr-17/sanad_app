import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanad/core/constants/colors.dart';
import 'package:sanad/core/widgets/custom_text.dart';
import 'package:sanad/features/client/client_requests/data/model/client_request.dart';
import 'package:sanad/features/client/client_requests/presentation/manager/client_requests_provider.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ClientRequestsScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const ClientRequestsScreen({super.key, this.onBackToHome});

  @override
  State<ClientRequestsScreen> createState() => _ClientRequestsScreenState();
}

class _ClientRequestsScreenState extends State<ClientRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientRequestsProvider>().loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final requestsProvider = context.watch<ClientRequestsProvider>();

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Cream,
        body: SafeArea(
          child: RefreshIndicator(
            color: DarkTeal,
            onRefresh: requestsProvider.loadRequests,
            child: Builder(
              builder: (context) {
                if (requestsProvider.requiresLogin) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _MessageState(
                        icon: Icons.person_outline,
                        message: l10n.requestsLoginRequired,
                      ),
                    ],
                  );
                }

                if (requestsProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: DarkTeal),
                  );
                }

                if (requestsProvider.error != null) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _MessageState(
                        icon: Icons.cloud_off_outlined,
                        message: l10n.ordersLoadError,
                        actionLabel: l10n.retryButton,
                        onAction: requestsProvider.loadRequests,
                      ),
                    ],
                  );
                }

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  children: [
                    _buildHeader(l10n, isArabic),
                    const SizedBox(height: 22),
                    if (requestsProvider.requests.isEmpty)
                      _MessageState(
                        icon: Icons.assignment_outlined,
                        message: l10n.noCustomerRequests,
                        description: l10n.noCustomerRequestsDescription,
                      )
                    else
                      ...requestsProvider.requests.map(
                        (request) => _RequestCard(
                          request: request,
                          locale: locale,
                          statusLabel: _statusLabel(request.status, l10n),
                          onTap: () =>
                              _showDetails(context, request, locale, l10n),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, bool isArabic) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              AppText(
                l10n.requestsTitle,
                style: const TextStyle(
                  color: DarkTeal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.requestsSubtitle,
                style: const TextStyle(color: DimGray, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: widget.onBackToHome,
          tooltip: l10n.homeNavigation,
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: DarkTeal,
            size: 18,
          ),
        ),
      ],
    );
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status.trim().toLowerCase()) {
      case 'pending':
      case 'new':
      case 'قيد الانتظار':
      case 'جديد':
        return l10n.pendingStatus;
      case 'confirmed':
      case 'accepted':
      case 'مؤكد':
      case 'تم التأكيد':
        return l10n.requestConfirmedStatus;
      case 'in_progress':
      case 'in progress':
      case 'جاري التنفيذ':
      case 'قيد التنفيذ':
        return l10n.requestInProgressStatus;
      case 'completed':
      case 'fulfilled':
      case 'done':
      case 'مكتمل':
      case 'تم التنفيذ':
        return l10n.fulfilledStatus;
      case 'cancelled':
      case 'canceled':
      case 'ملغي':
      case 'ملغى':
        return l10n.requestCancelledStatus;
      default:
        return status.isEmpty ? l10n.requestUnknownStatus : status;
    }
  }

  Future<void> _showDetails(
    BuildContext context,
    ClientRequest request,
    Locale locale,
    AppLocalizations l10n,
  ) {
    final date = request.scheduledAt ?? request.createdAt;
    final dateText = date == null
        ? l10n.requestDateUnavailable
        : DateFormat.yMMMd(locale.toLanguageTag()).format(date.toLocal());

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SeaShell,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Beige,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                l10n.requestDetailsTitle,
                style: const TextStyle(
                  color: DarkTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              _DetailRow(label: l10n.requestIdLabel, value: request.id),
              _DetailRow(
                label: l10n.requestServiceTypeLabel,
                value: request.serviceType.isEmpty
                    ? l10n.requestServiceUnavailable
                    : request.serviceType,
              ),
              _DetailRow(
                label: l10n.requestStatusLabel,
                value: _statusLabel(request.status, l10n),
              ),
              _DetailRow(label: l10n.requestDateLabel, value: dateText),
              if (request.address?.isNotEmpty ?? false)
                _DetailRow(
                  label: l10n.requestAddressLabel,
                  value: request.address!,
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: DarkTeal,
                  foregroundColor: SeaShell,
                ),
                child: Text(l10n.closeButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ClientRequest request;
  final Locale locale;
  final String statusLabel;
  final VoidCallback onTap;

  const _RequestCard({
    required this.request,
    required this.locale,
    required this.statusLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date = request.scheduledAt ?? request.createdAt;
    final dateText = date == null
        ? l10n.requestDateUnavailable
        : DateFormat.yMMMd(locale.toLanguageTag()).format(date.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: SeaShell,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Beige),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l10n.requestIdLabel}: ${request.id}',
                      style: const TextStyle(color: DimGray, fontSize: 11),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(request.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: const TextStyle(
                        color: DarkTeal,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                request.serviceType.isEmpty
                    ? l10n.requestServiceUnavailable
                    : request.serviceType,
                style: const TextStyle(
                  color: DarkTeal,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dateText,
                style: const TextStyle(color: DimGray, fontSize: 11),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(Icons.chevron_right, color: Rust, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('cancel') || normalized.contains('ملغ')) {
      return const Color(0xFFFFE3D8);
    }
    if (normalized.contains('complete') ||
        normalized.contains('fulfilled') ||
        normalized.contains('مكتمل')) {
      return const Color(0xFFDCEBDD);
    }
    return const Color(0xFFE6EBDD);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: DimGray, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: DarkTeal,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageState({
    required this.icon,
    required this.message,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.52,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: DimGray, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DarkTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: DimGray, fontSize: 12),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 16),
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
