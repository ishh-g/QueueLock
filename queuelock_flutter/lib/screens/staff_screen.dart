import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queuelock_client/queuelock_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Text(
                    'Your queues',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await client.auth.signOutDevice();
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Queue>>(
                future: _queues,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Could not load queues: ${snapshot.error}');
                  }
                  final queues = snapshot.data!;
                  if (queues.isEmpty) {
                    return const Text('No queues yet. Create one below.');
                  }
                  return Column(
                    children: [
                      for (final q in queues)
                        Card(
                          child: ListTile(
                            title: Text(q.name),
                            subtitle: Text(
                              '${q.status.name} · /q/${q.slug}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.go('/staff/${q.id}'),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Create a queue',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Queue name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _timeout,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Call timeout (seconds, min 10)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _creating ? null : _create,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Create'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
