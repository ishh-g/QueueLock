import 'package:flutter/material.dart';

import '../theme.dart';

/// Status badge: tinted status color plus an icon and a text label.
/// Status is never carried by color alone.
class StatusChip extends StatelessWidget {
  final String statusName;
  final String label;
  const StatusChip({super.key, required this.statusName, required this.label});

  static IconData iconFor(String statusName) {
    return switch (statusName) {
      'waiting' => Icons.schedule,
      'called' => Icons.campaign,
      'serving' => Icons.handshake_outlined,
      'done' => Icons.check_circle_outline,
      'skipped' || 'cancelled' => Icons.cancel_outlined,
      'open' => Icons.lock_open_outlined,
      'paused' => Icons.pause_circle_outline,
      'closed' => Icons.lock_outline,
      _ => Icons.info_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = AppTheme.statusColor(statusName, brightness);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: StadiumBorder(side: BorderSide(color: color)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconFor(statusName), size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
