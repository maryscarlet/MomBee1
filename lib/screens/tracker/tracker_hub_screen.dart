import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/journey_type.dart';
import '../../models/pregnancy_data.dart';
import '../../state/app_state.dart';
import 'period_tracker_screen.dart';
import 'pregnancy_tracker_screen.dart';
import 'baby_development_screen.dart';
import 'appointments_screen.dart';
import 'vaccination_screen.dart';

class TrackerHubScreen extends StatefulWidget {
  const TrackerHubScreen({super.key});

  @override
  State<TrackerHubScreen> createState() => _TrackerHubScreenState();
}

class _TrackerHubScreenState extends State<TrackerHubScreen> {
  void _showWaterTrackerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final waterGlasses = AppState.instance.waterGlasses;
          final goal = AppState.instance.dailyWaterGoal;
          final percent = AppState.instance.waterProgress;

          return Container(
            height: MediaQuery.of(context).size.height * 0.58,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Column(
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF29B6F6).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.water_drop_rounded,
                          color: Color(0xFF0288D1), size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'পানি পানের ট্র্যাকার',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'আজকের পানি পানের লক্ষ্যমাত্রা',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: CircularProgressIndicator(
                              value: percent,
                              strokeWidth: 10,
                              backgroundColor: AppColors.surfaceContainerHigh,
                              valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF29B6F6)),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${toBanglaDigits(waterGlasses)} / ${toBanglaDigits(goal)}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              Text(
                                '${(waterGlasses * 0.25).toStringAsFixed(1)} লিটার',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                            iconSize: 26,
                            onPressed: waterGlasses > 0
                                ? () => AppState.instance.removeWaterGlass()
                                : null,
                            icon: const Icon(Icons.remove_rounded),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.lg),
                              ),
                            ),
                            onPressed: () => AppState.instance.addWaterGlass(),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              '+১ গ্লাস পানি যোগ করুন',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontWeight: FontWeight.w700,
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final journey = AppState.instance.selectedJourney;
        final currentWeek = AppState.instance.currentPregnancyWeek;
        final isPregnancySetup = AppState.instance.isPregnancySetup;
        final periodData = AppState.instance.periodData;
        final babyData = AppState.instance.babyData;
        final waterGlasses = AppState.instance.waterGlasses;
        final appCount = AppState.instance.appointments.length;
        final vaccines = AppState.instance.vaccines;
        final completedVaccines = vaccines.where((v) => v.isCompleted).length;

        final periodItem = {
          'id': 'period',
          'title': 'পিরিয়ড ট্র্যাকার',
          'subtitle': 'সাইকেল দিন ${toBanglaDigits(periodData.currentCycleDay)}',
          'icon': Icons.calendar_month_rounded,
          'color': AppColors.primary,
          'action': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PeriodTrackerScreen()),
            );
          },
        };

        final pregnancyItem = {
          'id': 'pregnancy',
          'title': 'প্রেগন্যান্সি ট্র্যাকার',
          'subtitle': isPregnancySetup
              ? '${toBanglaDigits(currentWeek)}তম সপ্তাহ চলছে'
              : 'সেটআপ করুন',
          'icon': Icons.pregnant_woman_rounded,
          'color': AppColors.primary,
          'action': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PregnancyTrackerScreen()),
            );
          },
        };

        final babyItem = {
          'id': 'baby_age',
          'title': 'শিশুর বিকাশ',
          'subtitle': babyData.isSetup
              ? (babyData.name.isNotEmpty
                  ? '${babyData.name} (${babyData.ageStringBangla})'
                  : babyData.ageStringBangla)
              : 'মাইলফলক ও গাইড',
          'icon': Icons.child_care_rounded,
          'color': const Color(0xFF745B00),
          'action': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BabyDevelopmentScreen()),
            );
          },
        };

        final waterItem = {
          'id': 'water',
          'title': 'পানি পান',
          'subtitle': '${toBanglaDigits(waterGlasses)} / ১০ গ্লাস',
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFF0288D1),
          'action': _showWaterTrackerModal,
        };

        final appointmentsItem = {
          'id': 'appointments',
          'title': 'অ্যাপয়েন্টমেন্ট',
          'subtitle': '$appCount টি নির্ধারিত',
          'icon': Icons.event_available_rounded,
          'color': const Color(0xFF2E7D32),
          'action': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AppointmentsScreen()),
            );
          },
        };

        final vaccinesItem = {
          'id': 'vaccines',
          'title': 'টিকা ও ভ্যাকসিন',
          'subtitle': '$completedVaccines/${vaccines.length} সম্পন্ন',
          'icon': Icons.vaccines_rounded,
          'color': const Color(0xFF7B1FA2),
          'action': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VaccinationScreen()),
            );
          },
        };

        List<Map<String, dynamic>> trackers = [];
        if (journey == JourneyType.planning) {
          trackers = [
            periodItem,
            appointmentsItem,
            waterItem,
            vaccinesItem,
            babyItem,
            pregnancyItem,
          ];
        } else if (journey == JourneyType.pregnant) {
          trackers = [
            pregnancyItem,
            appointmentsItem,
            vaccinesItem,
            waterItem,
            periodItem,
            babyItem,
          ];
        } else if (journey == JourneyType.baby) {
          trackers = [
            babyItem,
            vaccinesItem,
            appointmentsItem,
            waterItem,
            periodItem,
            pregnancyItem,
          ];
        } else {
          trackers = [
            periodItem,
            waterItem,
            appointmentsItem,
            vaccinesItem,
            babyItem,
            pregnancyItem,
          ];
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceContainerLowest,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'ট্র্যাকার হাব',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.12,
                  ),
                  itemCount: trackers.length,
                  itemBuilder: (context, index) {
                    final tracker = trackers[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: tracker['action'] as VoidCallback,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            boxShadow: AppShadows.subtleCard,
                            border: Border.all(color: AppColors.borderCard),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (tracker['color'] as Color)
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  tracker['icon'] as IconData,
                                  size: 28,
                                  color: tracker['color'] as Color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tracker['title'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tracker['subtitle'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
