import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:queuelock_client/queuelock_client.dart';

import '../client.dart';
import '../theme.dart';

/// Public join page at `/q/:slug`: queue info plus nickname entry.
class JoinScreen extends StatefulWidget {
  final String slug;
  const JoinScreen({super.key, required this.slug});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late Future<QueueInfo> _info;
  final _nickname = TextEditingController();
  bool _joining = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _info = client.queue.info(widget.slug);
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    setState(() {
      _joining = true;
      _error = null;
    });
    try {
      final receipt = await client.queue.join(widget.slug, _nickname.text);
      if (!mounted) return;
      context.go('/t/${receipt.token}');
    } on QueueError catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Could not join: $e');
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join queue')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: FutureBuilder<QueueInfo>(
            future: _info,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _StateMessage(
                  message: 'Could not load this queue.',
                  onRetry: () => setState(
                    () => _info = client.queue.info(widget.slug),
                  ),
                );
              }
              final info = snapshot.data!;
              final open = info.queue.status == QueueStatus.open;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ...AnimateList(
                interval: 90.ms,
                effects: [
                  FadeEffect(duration: 300.ms, curve: Curves.easeOutCubic),
                  const SlideEffect(
                    begin: Offset(0, 0.1),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
                ],
                children: [
                  Text(
                    info.queue.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    open
                        ? '${info.waitingCount} waiting'
                        : 'This queue is not open right now.',
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nickname,
                    enabled: open && !_joining,
                    maxLength: 24,
                    decoration: const InputDecoration(
                      labelText: 'Nickname',
                      hintText: 'First name is enough',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _join(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.rose.withValues(alpha: 0.4),
                          blurRadius: 18,
                          spreadRadius: -6,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: open && !_joining ? _join : null,
                      child: _joining
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Join'),
                    ),
                  )
                      .animate(target: _joining ? 1 : 0)
                      .scaleXY(end: 0.97, duration: 120.ms),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ).animate().shake(duration: 300.ms),
                  ],
                  const SizedBox(height: 12),
                  const Text(
                    'Data-minimised: only a nickname, nothing else.',
                  ),
                ],
              ),
            ],
          ),
        );
            },
          ),
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _StateMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
