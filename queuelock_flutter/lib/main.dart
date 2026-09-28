import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'client.dart';
import 'screens/audit_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/join_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/staff_screen.dart';
import 'screens/ticket_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) usePathUrlStrategy();
  await initializeClient();
  runApp(QueueLockApp());
}

/// Shared 250 ms fade+scale route transition.
CustomTransitionPage<void> _page(Widget child) {
  return CustomTransitionPage(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
          child: child,
        ),
      );
    },
    child: child,
  );
}

class QueueLockApp extends StatelessWidget {
  QueueLockApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', pageBuilder: (_, _) => _page(const LandingScreen())),
      GoRoute(
        path: '/q/:slug',
        pageBuilder: (_, state) =>
            _page(JoinScreen(slug: state.pathParameters['slug']!)),
      ),
      GoRoute(
        path: '/t/:token',
        pageBuilder: (_, state) =>
            _page(TicketScreen(token: state.pathParameters['token']!)),
      ),
      GoRoute(
        path: '/staff',
        pageBuilder: (_, _) => _page(const StaffScreen()),
      ),
      GoRoute(
        path: '/audit/:slug',
        pageBuilder: (_, state) =>
            _page(AuditScreen(slug: state.pathParameters['slug']!)),
      ),
      GoRoute(
        path: '/staff/:queueId',
        pageBuilder: (_, state) => _page(
          DashboardScreen(
            queueId: int.tryParse(state.pathParameters['queueId'] ?? ''),
          ),
        ),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('QueueLock')),
      body: Center(child: Text('Not found: ${state.uri}')),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QueueLock',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
