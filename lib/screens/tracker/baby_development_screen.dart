import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/baby_stages_data.dart';
import '../../models/article.dart';
import '../../models/journey_type.dart';
import '../../widgets/article_widgets.dart';

class BabyDevelopmentScreen extends StatefulWidget {
  const BabyDevelopmentScreen({super.key});

  @override
  State<BabyDevelopmentScreen> createState() => _BabyDevelopmentScreenState();
}

class _BabyDevelopmentScreenState extends State<BabyDevelopmentScreen> {
  int _selectedStageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final stage = allBabyStages[_selectedStageIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'শিশুর বিকাশ গাইড',
          style: TextStyle(
            fontFamily: 'Noto Sans Bengali',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          // Horizontal Stage Selector
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: allBabyStages.length,
              itemBuilder: (context, index) {
                final st = allBabyStages[index];
                final isSelected = _selectedStageIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(st.ageRange),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedStageIndex = index);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.onSurface,
                    ),
                    backgroundColor: AppColors.surfaceContainerLow,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < -250 &&
                      _selectedStageIndex < allBabyStages.length - 1) {
                    setState(() => _selectedStageIndex++);
                  } else if (details.primaryVelocity! > 250 &&
                      _selectedStageIndex > 0) {
                    setState(() => _selectedStageIndex--);
                  }
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: ListView(
                  key: ValueKey<int>(_selectedStageIndex),
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // Header Card
                    Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.subtleCard,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.child_care_rounded,
                            size: 34, color: Color(0xFF745B00)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stage.title,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'শারীরিক ও মানসিক বিকাশের মাইলফলক',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Physical Growth
                _buildCard(
                  icon: Icons.height_rounded,
                  iconColor: AppColors.primary,
                  title: 'শারীরিক বৃদ্ধি ও ওজন',
                  content: stage.physicalGrowth,
                ),
                const SizedBox(height: 14),

                // 2. Cognitive Development
                _buildCard(
                  icon: Icons.psychology_rounded,
                  iconColor: const Color(0xFF7B1FA2),
                  title: 'মানসিক ও দৃষ্টি বিকাশ',
                  content: stage.cognitiveDevelopment,
                ),
                const SizedBox(height: 14),

                // 3. Feeding Guide
                _buildCard(
                  icon: Icons.restaurant_rounded,
                  iconColor: const Color(0xFFE65100),
                  title: 'খাওয়ানোর নিয়ম ও পুষ্টি',
                  content: stage.feedingGuide,
                ),
                const SizedBox(height: 14),

                // 4. Sleep Guide
                _buildCard(
                  icon: Icons.bedtime_rounded,
                  iconColor: const Color(0xFF0288D1),
                  title: 'ঘুমের সময়সূচি',
                  content: stage.sleepGuide,
                ),
                const SizedBox(height: 14),

                // 5. Milestones Checklist
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.subtleCard,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.emoji_events_rounded,
                              color: Color(0xFF745B00), size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'প্রধান মাইলফলকসমূহ',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...stage.milestones.map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    size: 18, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    m,
                                    style: const TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 13,
                                      height: 1.4,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 6. Care Tips
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                        color:
                            const Color(0xFF745B00).withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tips_and_updates_rounded,
                              color: Color(0xFF745B00), size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'যত্ন ও সুরক্ষা টিপস',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF745B00),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...stage.careTips.map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(
                                        color: Color(0xFF745B00),
                                        fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: const TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 13,
                                      height: 1.4,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                // Stage-Specific Articles & Doctor Guidance
                ...() {
                  final stageArticles = getArticlesForJourney(
                    JourneyType.baby,
                    babyStageId: stage.id,
                  );
                  if (stageArticles.isEmpty) return <Widget>[];

                  return <Widget>[
                    const SizedBox(height: 18),
                    Text(
                      '${stage.ageRange}-এর বিশেষজ্ঞ পরামর্শ ও গাইড',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...stageArticles.map(
                      (art) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => showMomBeeArticleDetails(context, art),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(color: AppColors.borderCard),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.sm),
                                    child: Image.network(
                                      art.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 60,
                                        height: 60,
                                        color: AppColors.surfaceContainerHigh,
                                        child: const Icon(Icons.article_rounded,
                                            size: 20, color: AppColors.outline),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          art.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Noto Sans Bengali',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                art.author,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Noto Sans Bengali',
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              art.readTime,
                                              style: const TextStyle(
                                                fontFamily: 'Noto Sans Bengali',
                                                fontSize: 11,
                                                color: AppColors.outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: AppColors.outline),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                }(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.subtleCard,
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Noto Sans Bengali',
              fontSize: 13,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
