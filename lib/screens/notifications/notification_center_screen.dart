import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/notification_item.dart';
import '../../state/app_state.dart';
import 'package:intl/intl.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String _selectedCategory = 'all';

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      if (difference.inMinutes <= 1) return 'এইমাত্র';
      return '${_toBanglaNumber(difference.inMinutes)} মিনিট আগে';
    } else if (difference.inHours < 24 && dt.day == now.day) {
      return 'আজ, ${DateFormat('hh:mm a').format(dt)}';
    } else if (difference.inDays == 1 ||
        (difference.inHours < 48 && dt.day == now.day - 1)) {
      return 'গতকাল, ${DateFormat('hh:mm a').format(dt)}';
    } else {
      return DateFormat('dd MMM, hh:mm a').format(dt);
    }
  }

  String _toBanglaNumber(int n) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var str = n.toString();
    for (int i = 0; i < 10; i++) {
      str = str.replaceAll(en[i], bn[i]);
    }
    return str;
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case NotificationCategory.water:
        return Icons.water_drop_rounded;
      case NotificationCategory.dailyCare:
        return Icons.lightbulb_rounded;
      case NotificationCategory.appointment:
        return Icons.event_available_rounded;
      case NotificationCategory.vaccine:
        return Icons.vaccines_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case NotificationCategory.water:
        return const Color(0xFF0288D1);
      case NotificationCategory.dailyCare:
        return AppColors.primary;
      case NotificationCategory.appointment:
        return const Color(0xFF2E7D32);
      case NotificationCategory.vaccine:
        return const Color(0xFFE65100);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final allItems = AppState.instance.notificationHistory;
        final filteredItems = _selectedCategory == 'all'
            ? allItems
            : allItems
                .where((item) => item.category == _selectedCategory)
                .toList();

        final unreadCount = AppState.instance.unreadNotificationCount;

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'নোটিফিকেশন সেন্টার',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            actions: [
              if (unreadCount > 0)
                TextButton.icon(
                  onPressed: () async {
                    await AppState.instance.markAllNotificationsAsRead();
                  },
                  icon: const Icon(Icons.done_all_rounded,
                      color: Colors.white, size: 18),
                  label: const Text(
                    'সব পঠিত',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Filter Chips
              Container(
                color: AppColors.surfaceContainerLowest,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'সবগুলো'),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          NotificationCategory.dailyCare, 'দৈনিক যত্ন'),
                      const SizedBox(width: 8),
                      _buildFilterChip(NotificationCategory.water, 'পানি পান'),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          NotificationCategory.appointment, 'অ্যাপয়েন্টমেন্ট'),
                      const SizedBox(width: 8),
                      _buildFilterChip(NotificationCategory.vaccine, 'টিকা'),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.surfaceDim),

              // Notification List
              Expanded(
                child: filteredItems.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final iconColor = _categoryColor(item.category);
                          final iconData = _categoryIcon(item.category);

                          return InkWell(
                            onTap: () async {
                              if (!item.isRead) {
                                await AppState.instance
                                    .markNotificationAsRead(item.id);
                              }
                            },
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: item.isRead
                                    ? AppColors.surfaceContainerLowest
                                    : AppColors.primary.withValues(alpha: 0.05),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.lg),
                                border: Border.all(
                                  color: item.isRead
                                      ? AppColors.surfaceDim
                                      : AppColors.primary.withValues(alpha: 0.25),
                                  width: item.isRead ? 1 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: iconColor.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(iconData,
                                        color: iconColor, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Noto Sans Bengali',
                                                  fontSize: 14.5,
                                                  fontWeight: item.isRead
                                                      ? FontWeight.w600
                                                      : FontWeight.w700,
                                                  color: AppColors.onSurface,
                                                ),
                                              ),
                                            ),
                                            if (!item.isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                    left: 6, top: 4),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.body,
                                          style: const TextStyle(
                                            fontFamily: 'Noto Sans Bengali',
                                            fontSize: 12.5,
                                            height: 1.4,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _formatTimestamp(item.timestamp),
                                          style: TextStyle(
                                            fontFamily: 'Noto Sans Bengali',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.onSurfaceVariant
                                                .withValues(alpha: 0.75),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(
        fontFamily: 'Noto Sans Bengali',
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.surfaceDim,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      onSelected: (_) {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'কোনো নোটিফিকেশন নেই',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'নতুন কোনো স্বাস্থ্য পরামর্শ বা রিমাইন্ডার আসলে এখানে দেখতে পাবেন।',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 12.5,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
