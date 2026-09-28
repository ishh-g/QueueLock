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

/// "Queue changed" ping on the per-queue message channel. Carries no
/// state: every open stream recomputes its own view from the database,
/// so a missed message can never leave a client wrong.
abstract class QueueChanged
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QueueChanged._({required this.queueId});

  factory QueueChanged({required int queueId}) = _QueueChangedImpl;

  factory QueueChanged.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueChanged(queueId: jsonSerialization['queueId'] as int);
  }

  int queueId;

  /// Returns a shallow copy of this [QueueChanged]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QueueChanged copyWith({int? queueId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueueChanged',
      'queueId': queueId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueueChanged',
      'queueId': queueId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _QueueChangedImpl extends QueueChanged {
  _QueueChangedImpl({required int queueId}) : super._(queueId: queueId);

  /// Returns a shallow copy of this [QueueChanged]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QueueChanged copyWith({int? queueId}) {
    return QueueChanged(queueId: queueId ?? this.queueId);
  }
}
