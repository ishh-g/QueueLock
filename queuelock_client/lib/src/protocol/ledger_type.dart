/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Tamper-evident ledger event types.
enum LedgerType implements _isc.SerializableModel {
  queueOpened,
  queuePaused,
  queueClosed,
  joined,
  called,
  servingStarted,
  completed,
  reentered,
  skipped,
  cancelled;

  static LedgerType fromJson(String name) {
    switch (name) {
      case 'queueOpened':
        return LedgerType.queueOpened;
      case 'queuePaused':
        return LedgerType.queuePaused;
      case 'queueClosed':
        return LedgerType.queueClosed;
      case 'joined':
        return LedgerType.joined;
      case 'called':
        return LedgerType.called;
      case 'servingStarted':
        return LedgerType.servingStarted;
      case 'completed':
        return LedgerType.completed;
      case 'reentered':
        return LedgerType.reentered;
      case 'skipped':
        return LedgerType.skipped;
      case 'cancelled':
        return LedgerType.cancelled;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "LedgerType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
