import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/journey_type.dart';
import '../../state/app_state.dart';
import 'views/home_planning_view.dart';
import 'home_pregnant_screen.dart';
import 'views/home_baby_view.dart';
import 'views/home_general_view.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;
  const HomeScreen({super.key, this.onNavigateTab});

  void _showChangeJourneyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'আপনার Journey পরিবর্তন করুন',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...JourneyType.values.map((journey) {
              final isCurrent = AppState.instance.selectedJourney == journey;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                tileColor: isCurrent
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : null,
                leading: Icon(
                  journey == JourneyType.planning
                      ? Icons.favorite_rounded
                      : journey == JourneyType.pregnant
                          ? Icons.pregnant_woman_rounded
                          : journey == JourneyType.baby
                              ? Icons.child_care_rounded
                              : Icons.menu_book_rounded,
                  color: isCurrent ? AppColors.primary : AppColors.outline,
                ),
                title: Text(
                  journey.titleBangla,
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
                trailing: isCurrent
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary)
                    : null,
                onTap: () async {
                  await AppState.instance.setJourney(journey);
                  if (context.mounted) Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentJourney = AppState.instance.selectedJourney;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: const Color(0xFFB90039),
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD8004E), Color(0xFF91002B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            title: Image.asset(
              'assets/images/logo_transparent.png',
              height: 32,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/logo.png',
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
            actions: [
              // Active Journey Switcher Chip on Maroon Header
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    onTap: () => _showChangeJourneyDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            currentJourney == JourneyType.planning
                                ? Icons.favorite_rounded
                                : currentJourney == JourneyType.pregnant
                                    ? Icons.pregnant_woman_rounded
                                    : currentJourney == JourneyType.baby
                                        ? Icons.child_care_rounded
                                        : Icons.menu_book_rounded,
                            size: 14,
                            color: const Color(0xFFFECB17),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            currentJourney.badgeBangla,
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('আপাতত নতুন কোনো নোটিফিকেশন নেই।',
                          style: TextStyle(fontFamily: 'Noto Sans Bengali')),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: KeyedSubtree(
              key: ValueKey<JourneyType>(currentJourney),
              child: _buildJourneyHome(currentJourney),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJourneyHome(JourneyType journey) {
    switch (journey) {
      case JourneyType.planning:
        return HomePlanningView(onNavigateTab: onNavigateTab);
      case JourneyType.pregnant:
        return HomePregnantScreen(onNavigateTab: onNavigateTab);
      case JourneyType.baby:
        return HomeBabyView(onNavigateTab: onNavigateTab);
      case JourneyType.general:
        return HomeGeneralView(onNavigateTab: onNavigateTab);
    }
  }
}
