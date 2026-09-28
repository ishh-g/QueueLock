import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:queuelock_client/queuelock_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme.dart';
import '../widgets/mesh_gradient.dart';
import '../widgets/status_chip.dart';
import 'sign_in_screen.dart';

/// Staff area at `/staff`: sign-in gate, queue list, create form.
class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      body: SignInScreen(child: const _Queues()),
    );
  }
}

class _Queues extends StatefulWidget {
  const _Queues();

  @override
  State<_Queues> createState() => _QueuesState();
}

class _QueuesState extends State<_Queues> {
  late Future<List<Queue>> _queues;
  final _name = TextEditingController();
  final _timeout = TextEditingController(text: '180');
  bool _creating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _queues = client.admin.myQueues();
  }

  @override
  void dispose() {
    _name.dispose();
    _timeout.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _queues = client.admin.myQueues());
    await _queues;
  }

  Future<void> _create() async {
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      final timeout = int.tryParse(_timeout.text.trim()) ?? 180;
      final queue = await client.admin.createQueue(
        _name.text,
        callTimeoutSec: timeout,
      );
      if (!mounted) return;
      context.go('/staff/${queue.id}');
    } on QueueError catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Could not create: $e');
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<List<Queue>>(
                  future: _queues,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                            ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 64),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          Text(
                            'Could not load queues: ${snapshot.error}',
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => setState(
                              () => _queues = client.admin.myQueues(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      );
                    }
                    final queues = snapshot.data!;
                    return Column(
                      children: [
                        ...AnimateList(
                          interval: 90.ms,
                          effects: [
                            FadeEffect(
                              duration: 320.ms,
                              curve: Curves.easeOutCubic,
                            ),
                            const SlideEffect(
                              begin: Offset(0, 0.1),
                              duration: Duration(milliseconds: 320),
                              curve: Curves.easeOutCubic,
                            ),
                          ],
                          children: [
                            _HeaderRow(
                              count: queues.length,
                              onSignOut: () async {
                                await client.auth.signOutDevice();
                              },
                            ),
                            const SizedBox(height: 12),
                            if (queues.isEmpty)
                              const _EmptyQueues()
                            else
                              for (final q in queues)
                                _QueueCard(
                                  key: ValueKey('queue-${q.id}'),
                                  queue: q,
                                  onOpen: () =>
                                      context.go('/staff/${q.id}'),
                                ),
                            const SizedBox(height: 20),
                            _CreateCard(
                              name: _name,
                              timeout: _timeout,
                              creating: _creating,
                              error: _error,
                              onCreate: _create,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final int count;
  final VoidCallback onSignOut;
  const _HeaderRow({required this.count, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const ShapeDecoration(
            color: AppTheme.maroon,
            shape: StadiumBorder(),
          ),
          child: const Icon(
            Icons.storefront_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your queues',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                count == 0
                    ? 'Nothing yet'
                    : '$count ${count == 1 ? 'queue' : 'queues'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Sign out',
          onPressed: onSignOut,
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
  }
}

class _EmptyQueues extends StatelessWidget {
  const _EmptyQueues();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.queue_outlined,
            size: 40,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          const Text('No queues yet'),
          Text(
            'Create your first below — it takes 20 seconds.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  final Queue queue;
  final VoidCallback onOpen;
  const _QueueCard({
    super.key,
    required this.queue,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        queue.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          StatusChip(
                            statusName: queue.status.name,
                            label: queue.status.name,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '/q/${queue.slug}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontFamily: 'monospace'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateCard extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController timeout;
  final bool creating;
  final String? error;
  final VoidCallback onCreate;
  const _CreateCard({
    required this.name,
    required this.timeout,
    required this.creating,
    required this.error,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle_outline, size: 22),
                const SizedBox(width: 8),
                Text(
                  'New queue',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Queue name',
                hintText: 'e.g. Main Clinic',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeout,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Call timeout (seconds, min 10)',
                helperText: '20 s shows timeouts fast · 180 s is normal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: creating ? null : onCreate,
              child: creating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create queue'),
            )
                .animate(target: creating ? 1 : 0)
                .scaleXY(end: 0.98, duration: 120.ms),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ).animate().shake(duration: 300.ms),
            ],
          ],
        ),
      ),
    );
  }
}
