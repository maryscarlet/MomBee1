import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/tracker_item.dart';
import '../../models/journey_type.dart';
import '../../state/app_state.dart';

class JourneySelectionScreen extends StatefulWidget {
  const JourneySelectionScreen({super.key});

  @override
  State<JourneySelectionScreen> createState() => _JourneySelectionScreenState();
}

class _JourneySelectionScreenState extends State<JourneySelectionScreen> {
  String _selectedStageId = 'pregnant';

  final List<JourneyStage> _stages = [
    const JourneyStage(
      id: 'planning',
      title: 'গর্ভধারণের পরিকল্পনা করছি',
      subtitle: 'প্রস্তুতি ও পরামর্শ',
      icon: Icons.favorite_rounded,
      iconBackgroundColor: Color(0xFFFFE08D),
      iconColor: Color(0xFF584400),
    ),
    const JourneyStage(
      id: 'pregnant',
      title: 'আমি গর্ভবতী',
      subtitle: 'সপ্তাহ অনুযায়ী ট্র্যাকিং',
      icon: Icons.pregnant_woman_rounded,
      iconBackgroundColor: Color(0xFFFFDADB),
      iconColor: Color(0xFF91002B),
    ),
    const JourneyStage(
      id: 'baby',
      title: 'আমার শিশু আছে',
      subtitle: 'শিশুর বৃদ্ধি ও পুষ্টি',
      icon: Icons.child_care_rounded,
      iconBackgroundColor: Color(0xFFFFE999),
      iconColor: Color(0xFF6F5700),
    ),
    const JourneyStage(
      id: 'general',
      title: 'শুধু তথ্য জানতে চাই',
      subtitle: 'আর্টিকেল ও গাইড',
      icon: Icons.menu_book_rounded,
      iconBackgroundColor: Color(0xFFE7E1E2),
      iconColor: Color(0xFF494647),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedStageId = AppState.instance.selectedJourney.id;
  }

  Future<void> _selectStage(String id) async {
    setState(() {
      _selectedStageId = id;
    });

    final journey = JourneyTypeExtension.fromString(id);
    await AppState.instance.setJourney(journey);

    // Smooth navigation into Main App
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Decorative blobs
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.2),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryFixed.withValues(alpha: 0.3),
                ),
              ),
            ),

            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 36,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header
                    Text(
                      'আপনি এখন কোন পর্যায়ে আছেন?',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'আমরা আপনাকে সঠিক তথ্য দিয়ে সাহায্য করতে চাই',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Cards
                    ..._stages.map((stage) {
                      final isSelected = _selectedStageId == stage.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectStage(stage.id),
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            splashColor:
                                AppColors.primary.withValues(alpha: 0.08),
                            highlightColor:
                                AppColors.primary.withValues(alpha: 0.04),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.xl),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.12),
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : AppShadows.subtleCard,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: stage.iconBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      stage.icon,
                                      color: stage.iconColor,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stage.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.onSurface,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          stage.subtitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle_rounded
                                        : Icons.chevron_right_rounded,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.outline
                                            .withValues(alpha: 0.5),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
