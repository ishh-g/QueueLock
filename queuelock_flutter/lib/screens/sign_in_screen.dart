import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme.dart';
import '../widgets/mesh_gradient.dart';

/// Staff sign-in gate: branded card framing the auth widget, with the
/// same staggered entrance as the rest of the app.
class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) return widget.child;

    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: MeshGradient(
            base: dark ? AppTheme.darkBackground : AppTheme.cream,
            blobs: dark
                ? [
                    AppTheme.maroon.withValues(alpha: 0.5),
                    AppTheme.matcha.withValues(alpha: 0.22),
                    AppTheme.rose.withValues(alpha: 0.14),
                  ]
                : [
                    AppTheme.maroon.withValues(alpha: 0.16),
                    AppTheme.matcha.withValues(alpha: 0.35),
                    AppTheme.rose.withValues(alpha: 0.2),
                  ],
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ...AnimateList(
                    interval: 110.ms,
                    effects: [
                      FadeEffect(
                        duration: 350.ms,
                        curve: Curves.easeOutCubic,
                      ),
                      const SlideEffect(
                        begin: Offset(0, 0.12),
                        duration: Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const ShapeDecoration(
                          color: AppTheme.maroon,
                          shape: StadiumBorder(),
                        ),
                        child: const Icon(
                          Icons.storefront_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Staff sign-in',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'One account owns your queues. Customers never see this '
                        'page — they join with just a nickname.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SignInWidget(
                            client: client,
                            buttonStyle: const SignInButtonStyle(
                              backgroundColor: AppTheme.maroon,
                              foregroundColor: Colors.white,
                              shape: SignInButtonShape.rounded,
                            ),
                            onAuthenticated: () {
                              context.showSnackBar(
                                message: 'User authenticated.',
                                backgroundColor: colors.primaryContainer,
                                foregroundColor: colors.onPrimaryContainer,
                              );
                            },
                            onError: (error) {
                              context.showSnackBar(
                                message: 'Authentication failed: $error',
                                backgroundColor: colors.errorContainer,
                                foregroundColor: colors.onErrorContainer,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension on BuildContext {
  void showSnackBar({
    required String message,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: foregroundColor)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
