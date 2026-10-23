import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/main_navigation_shell.dart';
import '../screens/notifications/notification_center_screen.dart';
import '../screens/tracker/appointments_screen.dart';
import '../screens/tracker/period_tracker_screen.dart';
import '../screens/tracker/vaccination_screen.dart';
import '../widgets/daily_message_card.dart';
import '../widgets/water_tracker_modal.dart';

/// Global navigator key attached to root MaterialApp.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Centralized coordinator for notification tap routing across all app lifecycle states
/// (foreground, background, and cold launch from terminated state).
class NotificationNavigationHandler {
  NotificationNavigationHandler._();
  static final NotificationNavigationHandler instance =
      NotificationNavigationHandler._();

  String? _pendingPayload;
  bool _isAppReady = false;
  bool _isNavigating = false;

  /// Stores a payload to navigate to once the main UI is ready (used during cold launch).
  void setPendingPayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) return;
    _pendingPayload = payload;
  }

  /// Called when MainNavigationShell is mounted and ready to accept navigation events.
  void onAppReady() {
    _isAppReady = true;
    if (_pendingPayload != null) {
      final payload = _pendingPayload;
      _pendingPayload = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handlePayload(payload);
      });
    }
  }

  /// Parses the notification payload and navigates safely to the designated destination.
  Future<void> handlePayload(String? payload) async {
    if (payload == null || payload.trim().isEmpty) return;

    if (!_isAppReady || rootNavigatorKey.currentState == null) {
      setPendingPayload(payload);
      return;
    }

    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final context = rootNavigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      final navigator = rootNavigatorKey.currentState;
      if (navigator != null) {
        // Pop any open sub-modals/screens until root of /main
        navigator.popUntil((route) => route.isFirst || route.settings.name == '/main');
      }

      String type = payload.trim();

      // Parse JSON payload format e.g. {"type": "water", "id": "123"}
      if (payload.startsWith('{') && payload.endsWith('}')) {
        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          type = data['type'] as String? ?? '';
        } catch (_) {
          type = payload.trim();
        }
      }

      switch (type.toLowerCase()) {
        case 'water':
          MainNavigationShell.switchToTab(1); // Tracker Hub
          final activeContext = rootNavigatorKey.currentContext;
          if (activeContext != null && activeContext.mounted) {
            WaterTrackerModal.show(activeContext);
          }
          break;

        case 'daily_care':
        case 'dailycare':
          MainNavigationShell.switchToTab(0); // Home
          final activeContext = rootNavigatorKey.currentContext;
          if (activeContext != null && activeContext.mounted) {
            DailyMessageCard.showDetailModal(activeContext);
          }
          break;

        case 'appointment':
        case 'appointments':
          navigator?.push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/appointments'),
              builder: (ctx) => const AppointmentsScreen(),
            ),
          );
          break;

        case 'vaccine':
        case 'vaccines':
          navigator?.push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/vaccines'),
              builder: (ctx) => const VaccinationScreen(),
            ),
          );
          break;

        case 'period':
        case 'period_reminder':
        case 'ovulation':
        case 'ovulation_reminder':
          navigator?.push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/period-tracker'),
              builder: (ctx) => const PeriodTrackerScreen(),
            ),
          );
          break;

        case 'test':
        case 'general':
        default:
          navigator?.push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/notification-center'),
              builder: (ctx) => const NotificationCenterScreen(),
            ),
          );
          break;
      }
    } catch (e) {
      debugPrint('Error navigating from notification payload: $e');
    } finally {
      _isNavigating = false;
    }
  }
}
