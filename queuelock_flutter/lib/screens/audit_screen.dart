import 'package:flutter/material.dart';
import 'package:queuelock_client/queuelock_client.dart';

import '../client.dart';

const _pageSize = 50;

/// Public audit page at `/audit/:slug`: chain status, entry list, and a
/// "check my receipt" box. Everything here is public and tamper-evident:
///
/// customers keep `(seq, hash)` receipts and anyone can recompute the chain.
class AuditScreen extends StatefulWidget {
  final String slug;
  const AuditScreen({super.key, required this.slug});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  late Future<VerifyResult> _verify;
  final List<LedgerEntry> _entries = [];
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _listError;

  final _seq = TextEditingController();
  final _hash = TextEditingController();
  bool _checking = false;
  bool? _match;

  @override
  void initState() {
    super.initState();
    _verify = client.audit.verify(widget.slug);
    _loadMore();
  }

  @override
  void dispose() {
    _seq.dispose();
    _hash.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() {
      _loadingMore = true;
      _listError = null;
    });
    try {
      final afterSeq = _entries.isEmpty ? 0 : _entries.last.seq;
      final page = await client.audit.ledger(
        widget.slug,
        afterSeq: afterSeq,
        limit: _pageSize,
      );
      setState(() {
        _entries.addAll(page);
        _hasMore = page.length == _pageSize;
      });
    } on QueueError catch (e) {
      setState(() => _listError = e.message);
    } catch (e) {
      setState(() => _listError = 'Could not load entries: $e');
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  Future<void> _check() async {
    final seq = int.tryParse(_seq.text.trim());
    if (seq == null || _hash.text.trim().isEmpty) {
      setState(() => _match = null);
      return;
    }
    setState(() {
      _checking = true;
      _match = null;
    });
    try {
      final ok = await client.audit.checkReceipt(
        widget.slug,
        seq,
        _hash.text.trim(),
      );
      if (mounted) setState(() => _match = ok);
    } catch (_) {
      if (mounted) setState(() => _match = false);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue audit')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatusCard(verify: _verify),
              const SizedBox(height: 16),
              _ReceiptBox(
                seq: _seq,
                hash: _hash,
                checking: _checking,
                match: _match,
                onCheck: _check,
              ),
              const SizedBox(height: 16),
              Text(
                'Log entries (${_entries.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (_listError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _listError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                OutlinedButton(
                  onPressed: _loadMore,
                  child: const Text('Retry'),
                ),
              ],
              for (final entry in _entries) _EntryRow(entry: entry),
              if (_entries.isEmpty && !_loadingMore && _listError == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No entries yet.'),
                ),
              if (_loadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_hasMore && !_loadingMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: OutlinedButton(
                    onPressed: _loadMore,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Load more'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Future<VerifyResult> verify;
  const _StatusCard({required this.verify});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder<VerifyResult>(
      future: verify,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Could not verify: ${snapshot.error}'),
            ),
          );
        }
        final result = snapshot.data!;
        final ok = result.ok;
        return Card(
          color: ok ? colors.primaryContainer : colors.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ok
                      ? 'Chain verified · ${result.entryCount} entries'
                      : 'Chain broken at entry ${result.firstBadSeq}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  ok
                      ? 'Every entry links to the previous one. A rewritten '
                            'history would contradict customer receipts.'
                      : 'The log does not match its hashes from this entry on. '
                            'Do not trust entries at or after it.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptBox extends StatelessWidget {
  final TextEditingController seq;
  final TextEditingController hash;
  final bool checking;
  final bool? match;
  final VoidCallback onCheck;
  const _ReceiptBox({
    required this.seq,
    required this.hash,
    required this.checking,
    required this.match,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check my receipt',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: seq,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'seq',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: hash,
                    decoration: const InputDecoration(
                      labelText: 'hash',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: checking ? null : onCheck,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Check'),
            ),
            if (match != null) ...[
              const SizedBox(height: 8),
              Text(
                match!
                    ? 'Receipt matches the public log.'
                    : 'No match. Check the numbers or ask staff.',
                style: TextStyle(
                  color: match!
                      ? Colors.green.shade700
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  final LedgerEntry entry;
  const _EntryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      entry.tsMs,
      isUtc: true,
    ).toLocal();
    final detail = [
      '#${entry.seq}',
      entry.type.name,
      if (entry.ticketNumber != null) 'ticket ${entry.ticketNumber}',
      if (entry.counterId != null) 'counter ${entry.counterId}',
      if (entry.detail != null) entry.detail!,
    ].join(' · ');
    return ListTile(
      dense: true,
      title: Text(detail),
      subtitle: Text(
        '$time\n${entry.hash.substring(0, 16)}…',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}
