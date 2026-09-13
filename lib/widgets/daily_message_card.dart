import 'package:flutter/material.dart';
import '../services/daily_message_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class DailyMessageCard extends StatefulWidget {
  const DailyMessageCard({super.key});

  @override
  State<DailyMessageCard> createState() => _DailyMessageCardState();
}

class _DailyMessageCardState extends State<DailyMessageCard>
    with SingleTickerProviderStateMixin {
  bool _isDismissingLocally = false;

  void _handleMarkAsRead(BuildContext context) async {
    setState(() => _isDismissingLocally = true);
    await Future.delayed(const Duration(milliseconds: 320));
    await AppState.instance.dismissDailyMessage();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'আজকের বার্তা পড়া হয়েছে!',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDetailModal(BuildContext context, DailyMessage msg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        msg.category,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      msg.greeting,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  msg.title,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  msg.message,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border:
                        Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.format_quote_rounded,
                          color: AppColors.primary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.doctorQuote,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.verified_user_rounded,
                                    size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${msg.doctorName} • ${msg.doctorRole}',
                                    style: const TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleMarkAsRead(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                    label: const Text(
                      'পড়েছি, ধন্যবাদ',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isDismissed = AppState.instance.isDailyMessageDismissedToday;
        if (isDismissed) {
          return const SizedBox.shrink();
        }

        final msg = DailyMessageService.getDailyMessageForCurrentProfile();

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: _isDismissingLocally
              ? const SizedBox(width: double.infinity, height: 0)
              : AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _isDismissingLocally ? 0.0 : 1.0,
                  curve: Curves.easeOut,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 18.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF6F7),
                    AppColors.surfaceContainerLowest,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                boxShadow: AppShadows.subtleCard,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => _showDetailModal(context, msg),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lightbulb_outline_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'আজকের বার্তা • ${msg.greeting}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            // Quick Mark as Read Action
                            InkWell(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              onTap: () => _handleMarkAsRead(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                  border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.2)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_rounded,
                                        size: 13, color: AppColors.primary),
                                    SizedBox(width: 4),
                                    Text(
                                      'পড়েছি',
                                      style: TextStyle(
                                        fontFamily: 'Noto Sans Bengali',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          msg.title,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.verified_user_outlined,
                                size: 13, color: AppColors.outline),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'পরামর্শক: ${msg.doctorName} (${msg.doctorRole})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  color: AppColors.outline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'বিস্তারিত',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                size: 16, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
