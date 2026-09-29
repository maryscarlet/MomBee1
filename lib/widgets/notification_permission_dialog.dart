import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({super.key});

  /// Check if permission has been prompted before; if not, show the dialog once.
  static Future<void> checkAndShow(BuildContext context) async {
    final prompted =
        await LocalStorageService.hasPromptedNotificationPermission();
    if (prompted) return;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const NotificationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      backgroundColor: AppColors.surfaceContainerLowest,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'নোটিফিকেশন রিমাইন্ডার চালু করুন',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'সঠিক সময়ে পানি পানের তাগিদ, ডাক্তারের অ্যাপয়েন্টমেন্ট এবং আপনার গর্ভকালীন/মাতৃত্বকালীন দৈনিক স্বাস্থ্য পরামর্শ পেতে নোটিফিকেশনের অনুমতি দিন।',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 13,
                height: 1.45,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await LocalStorageService.saveNotificationPermissionPrompted(
                      true);
                  if (context.mounted) Navigator.pop(context);
                  await NotificationService.instance.requestPermissions();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'অনুমতি দিন',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await LocalStorageService.saveNotificationPermissionPrompted(
                    true);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text(
                'পরে করব',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
