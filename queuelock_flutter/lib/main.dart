import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'client.dart';
import 'screens/dashboard_screen.dart';
import 'screens/join_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/staff_screen.dart';
import 'screens/ticket_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) usePathUrlStrategy();
  await initializeClient();
  runApp(QueueLockApp());
}

class QueueLockApp extends StatelessWidget {
  QueueLockApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const LandingScreen()),
      GoRoute(
        path: '/q/:slug',
        builder: (_, state) =>
            JoinScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/t/:token',
        builder: (_, state) =>
            TicketScreen(token: state.pathParameters['token']!),
      ),
      GoRoute(path: '/staff', builder: (_, _) => const StaffScreen()),
      GoRoute(
        path: '/staff/:queueId',
        builder: (_, state) => DashboardScreen(
          queueId: int.tryParse(state.pathParameters['queueId'] ?? ''),
        ),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('QueueLock')),
      body: Center(child: Text('Not found: ${state.uri}')),
    ),
  );

  ThemeData _theme(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: brightness,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QueueLock',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
