import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../services/app_localization.dart';
import 'home/home_screen.dart';
import 'tracker/tracker_hub_screen.dart';
import 'learn/learn_hub_screen.dart';
import 'video/video_library_screen.dart';
import 'package:mombee_app/screens/profile/profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;
  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigateTab: _onTabSelected),
          const TrackerHubScreen(),
          const LearnHubScreen(),
          const VideoLibraryScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: SafeArea(
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        index: 0,
                        icon: Icons.home_rounded,
                        label: AppLocalization.navHome,
                      ),
                      _buildNavItem(
                        index: 1,
                        icon: Icons.insights_rounded,
                        label: AppLocalization.navTracker,
                      ),
                      _buildNavItem(
                        index: 2,
                        icon: Icons.menu_book_rounded,
                        label: AppLocalization.navLearn,
                      ),
                      _buildNavItem(
                        index: 3,
                        icon: Icons.play_circle_rounded,
                        label: AppLocalization.navVideos,
                      ),
                      _buildNavItem(
                        index: 4,
                        icon: Icons.person_rounded,
                        label: AppLocalization.navProfile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTabSelected(index),
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
