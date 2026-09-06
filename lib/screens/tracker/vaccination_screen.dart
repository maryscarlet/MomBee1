import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/pregnancy_data.dart';
import '../../state/app_state.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Maternal, 2: Baby EPI

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final vaccines = AppState.instance.vaccines;
        final completedCount = vaccines.where((v) => v.isCompleted).length;

        final filteredList = vaccines.where((v) {
          if (_selectedFilterIndex == 1) return v.targetAudience == 'গর্ভকালীন';
          if (_selectedFilterIndex == 2) return v.targetAudience != 'গর্ভকালীন';
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceContainerLowest,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'টিকা ট্র্যাকার ও শিডিউল',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // 1. STATS BANNER
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      const Color(0xFFFFF6D6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.subtleCard,
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: vaccines.isEmpty
                                ? 0.0
                                : (completedCount / vaccines.length),
                            strokeWidth: 6,
                            backgroundColor: Colors.white,
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        ),
                        Text(
                          '${toBanglaDigits(completedCount)}/${toBanglaDigits(vaccines.length)}',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'জাতীয় ইপিআই ও গর্ভকালীন টিকা',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedCount টি সম্পন্ন • ${vaccines.length - completedCount} টি বাকি',
                            style: const TextStyle(
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

              // 2. FILTER PILLS
              Row(
                children: [
                  _buildFilterChip(0, 'সব টিকা'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, 'মায়ের টিকা'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'শিশুর ইপিআই'),
                ],
              ),
              const SizedBox(height: 16),

              // 3. VACCINE CHECKLIST
              ...filteredList.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.subtleCard,
                    border: Border.all(
                      color: item.isCompleted
                          ? const Color(0xFF81C784).withValues(alpha: 0.5)
                          : AppColors.borderCard,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          item.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: item.isCompleted
                              ? const Color(0xFF2E7D32)
                              : AppColors.outline,
                          size: 26,
                        ),
                        onPressed: () {
                          AppState.instance.toggleVaccineCompletion(item.id);
                        },
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: item.targetAudience == 'গর্ভকালীন'
                                        ? AppColors.primary.withValues(alpha: 0.1)
                                        : AppColors.secondaryFixed,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.targetAudience,
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: item.targetAudience == 'গর্ভকালীন'
                                          ? AppColors.primary
                                          : const Color(0xFF745B00),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (item.isCompleted)
                                  const Text(
                                    'সম্পন্ন',
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.isCompleted
                                    ? AppColors.outline
                                    : AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 13, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.schedule,
                                    style: const TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                height: 1.4,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedFilterIndex = index);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontFamily: 'Noto Sans Bengali',
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.onSurface,
      ),
      backgroundColor: AppColors.surfaceContainerLow,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
