import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../state/app_state.dart';
import '../../../services/bangla_date_helper.dart';

/// Clean, minimal greeting header displaying dynamic time-based greeting with
/// user's saved name and today's formatted Bangla date.
class HomeGreetingHeader extends StatelessWidget {
  final String? emoji;
  const HomeGreetingHeader({super.key, this.emoji});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final now = DateTime.now();
        final greetingPhrase = BanglaDateHelper.getGreetingPhrase(dateTime: now);
        final userName = AppState.instance.userName.trim();
        final dateStr = BanglaDateHelper.formatBanglaDate(now);
        final displayEmoji = emoji ?? '🌸';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    greetingPhrase,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          letterSpacing: -0.2,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(displayEmoji, style: const TextStyle(fontSize: 22)),
                ],
              ),
              if (userName.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
