import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/user_name_setup_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/journey/journey_selection_screen.dart';
import 'screens/main_navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await AppState.instance.initialize();
  runApp(const MomBeeApp());
}

class MomBeeApp extends StatelessWidget {
  const MomBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MomBee - Parenting Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/user-setup': (context) => const UserNameSetupScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/journey-selection': (context) => const JourneySelectionScreen(),
        '/main': (context) => const MainNavigationShell(),
      },
    );
  }
}
