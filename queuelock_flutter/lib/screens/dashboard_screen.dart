import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:queuelock_client/queuelock_client.dart';

import '../client.dart';
import 'sign_in_screen.dart';

/// Counter dashboard at `/staff/:queueId`: pick a counter, call next,
/// serve the current ticket, watch the waiting list live.
class DashboardScreen extends StatelessWidget {
  final int? queueId;
  const DashboardScreen({super.key, required this.queueId});

  @override
  Widget build(BuildContext context) {
    if (queueId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: const Center(child: Text('Invalid queue id.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: SignInScreen(child: _Dashboard(queueId: queueId!)),
    );
  }
}

class _Dashboard extends StatefulWidget {
  final int queueId;
  const _Dashboard({required this.queueId});

  @override
  State<_Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard> {
  late final Stream<QueueSnapshot> _stream;
  int? _counterId;
  final _newCounter = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _stream = client.counter.watchQueue(widget.queueId);
  }

  @override
  void dispose() {
    _newCounter.dispose();
    super.dispose();
  }

  void _fail(Object e) {
    final message = e is QueueError ? e.message : 'Request failed: $e';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      _fail(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: StreamBuilder<QueueSnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Could not load queue: ${snapshot.error}'),
              );
            }
            final snap = snapshot.data!;
            final reconnecting =
                snapshot.connectionState == ConnectionState.waiting;
            if (_counterId != null &&
                snap.counters.every((c) => c.id != _counterId)) {
              _counterId = null;
            }
            _counterId ??= snap.counters.isNotEmpty
                ? snap.counters.first.id
                : null;
            return _Body(
              snap: snap,
              reconnecting: reconnecting,
              busy: _busy,
              counterId: _counterId,
              newCounter: _newCounter,
              onPickCounter: (id) => setState(() => _counterId = id),
              onCallNext: _counterId == null
                  ? null
                  : () => _run(
                      () async => client.counter.callNext(_counterId!),
                    ),
              onStartServing: (id) => _run(
                () async => client.counter.startServing(id),
              ),
              onComplete: (id) => _run(
                () async =>
                    client.counter.complete(id, callNext: false),
              ),
              onCompleteAndNext: (id) => _run(
                () async => client.counter.complete(id, callNext: true),
              ),
              onSkip: (id) => _run(() async => client.counter.skip(id)),
              onAddCounter: () => _run(() async {
                await client.admin.addCounter(
                  widget.queueId,
                  _newCounter.text,
                );
                _newCounter.clear();
              }),
              onSetStatus: (status) => _run(
                () async =>
                    client.admin.setStatus(widget.queueId, status),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final QueueSnapshot snap;
  final bool reconnecting;
  final bool busy;
  final int? counterId;
  final TextEditingController newCounter;
  final ValueChanged<int?> onPickCounter;
  final VoidCallback? onCallNext;
  final ValueChanged<int> onStartServing;
  final ValueChanged<int> onComplete;
  final ValueChanged<int> onCompleteAndNext;
  final ValueChanged<int> onSkip;
  final VoidCallback onAddCounter;
  final ValueChanged<QueueStatus> onSetStatus;

  const _Body({
    required this.snap,
    required this.reconnecting,
    required this.busy,
    required this.counterId,
    required this.newCounter,
    required this.onPickCounter,
    required this.onCallNext,
    required this.onStartServing,
    required this.onComplete,
    required this.onCompleteAndNext,
    required this.onSkip,
    required this.onAddCounter,
    required this.onSetStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (reconnecting)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Reconnecting…'),
          ),
        Text(snap.queueName, style: theme.textTheme.headlineSmall),
        Text('Join at /q/${snap.slug}'),
        const SizedBox(height: 8),
        _JoinQr(slug: snap.slug),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Status: ${snap.status.name}'),
            for (final s in QueueStatus.values)
              ChoiceChip(
                label: Text(s.name),
                selected: snap.status == s,
                onSelected: busy ? null : (_) => onSetStatus(s),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          snap.sampleCount > 0
              ? 'About ${(snap.avgServiceSec / 60).toStringAsFixed(1)} min per service, based on ${snap.sampleCount} recent services.'
              : 'Estimate improves as we serve people.',
        ),
        const Divider(height: 32),
        Text('Counter', style: theme.textTheme.titleMedium),
        DropdownButton<int>(
          value: counterId,
          hint: const Text('Pick a counter'),
          items: [
            for (final c in snap.counters)
              DropdownMenuItem(
                value: c.id,
                child: Text('${c.name}${c.active ? '' : ' (inactive)'}'),
              ),
          ],
          onChanged: onPickCounter,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: newCounter,
                decoration: const InputDecoration(
                  labelText: 'New counter name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: busy ? null : onAddCounter,
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: busy ? null : onCallNext,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          child: const Text('Call next', style: TextStyle(fontSize: 20)),
        ),
        const Divider(height: 32),
        _TicketSection(
          title: 'Called',
          tickets: snap.called,
          busy: busy,
          onStartServing: onStartServing,
          onComplete: onComplete,
          onCompleteAndNext: onCompleteAndNext,
          onSkip: onSkip,
        ),
        _TicketSection(
          title: 'Serving',
          tickets: snap.serving,
          busy: busy,
          onStartServing: onStartServing,
          onComplete: onComplete,
          onCompleteAndNext: onCompleteAndNext,
          onSkip: onSkip,
        ),
        _TicketSection(
          title: 'Waiting (${snap.waiting.length})',
          tickets: snap.waiting,
          busy: busy,
          onStartServing: onStartServing,
          onComplete: onComplete,
          onCompleteAndNext: onCompleteAndNext,
          onSkip: onSkip,
        ),
      ],
    );
  }
}

/// QR code of the public join link. Print it or show it at the venue:
/// customers scan it with any phone camera, no app install.
class _JoinQr extends StatelessWidget {
  final String slug;
  const _JoinQr({required this.slug});

  @override
  Widget build(BuildContext context) {
    final url = '${Uri.base.origin}/q/$slug';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            QrImageView(data: url, size: 140),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer join link',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  SelectableText(url),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketSection extends StatelessWidget {
  final String title;
  final List<TicketPublic> tickets;
  final bool busy;
  final ValueChanged<int> onStartServing;
  final ValueChanged<int> onComplete;
  final ValueChanged<int> onCompleteAndNext;
  final ValueChanged<int> onSkip;

  const _TicketSection({
    required this.title,
    required this.tickets,
    required this.busy,
    required this.onStartServing,
    required this.onComplete,
    required this.onCompleteAndNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (tickets.isEmpty) const Text('—'),
        for (final t in tickets)
          Card(
            child: ListTile(
              title: Text('#${t.number} ${t.nickname ?? ''}'.trim()),
              subtitle: Text(
                t.counterName == null ? t.status.name : '${t.status.name} · ${t.counterName}',
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  if (t.status == TicketStatus.called)
                    ElevatedButton(
                      onPressed: busy ? null : () => onStartServing(t.id),
                      child: const Text('Start'),
                    ),
                  if (t.status == TicketStatus.serving) ...[
                    ElevatedButton(
                      onPressed: busy ? null : () => onComplete(t.id),
                      child: const Text('Done'),
                    ),
                    ElevatedButton(
                      onPressed: busy ? null : () => onCompleteAndNext(t.id),
                      child: const Text('Done+next'),
                    ),
                  ],
                  if (t.status == TicketStatus.called ||
                      t.status == TicketStatus.serving)
                    TextButton(
                      onPressed: busy ? null : () => onSkip(t.id),
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
