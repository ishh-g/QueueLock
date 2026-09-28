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
import 'package:queuelock_client/src/protocol/protocol.dart' as _i63o5r82;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'counter.dart' as _i1h51zb1;
import 'queue.dart' as _id7z6zkg;

/// Public queue snapshot: queue row plus live counters.
abstract class QueueInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QueueInfo._({
    required this.queue,
    required this.waitingCount,
    required this.counters,
  });

  factory QueueInfo({
    required _id7z6zkg.Queue queue,
    required int waitingCount,
    required List<_i1h51zb1.Counter> counters,
  }) = _QueueInfoImpl;

  factory QueueInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueInfo(
      queue: _i63o5r82.Protocol().deserialize<_id7z6zkg.Queue>(
        jsonSerialization['queue'],
      ),
      waitingCount: jsonSerialization['waitingCount'] as int,
      counters: _i63o5r82.Protocol().deserialize<List<_i1h51zb1.Counter>>(
        jsonSerialization['counters'],
      ),
    );
  }

  _id7z6zkg.Queue queue;

  int waitingCount;

  List<_i1h51zb1.Counter> counters;

  /// Returns a shallow copy of this [QueueInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QueueInfo copyWith({
    _id7z6zkg.Queue? queue,
    int? waitingCount,
    List<_i1h51zb1.Counter>? counters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueueInfo',
      'queue': queue.toJson(),
      'waitingCount': waitingCount,
      'counters': counters.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueueInfo',
      'queue': queue.toJsonForProtocol(),
      'waitingCount': waitingCount,
      'counters': counters.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _QueueInfoImpl extends QueueInfo {
  _QueueInfoImpl({
    required _id7z6zkg.Queue queue,
    required int waitingCount,
    required List<_i1h51zb1.Counter> counters,
  }) : super._(
         queue: queue,
         waitingCount: waitingCount,
         counters: counters,
       );

  /// Returns a shallow copy of this [QueueInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QueueInfo copyWith({
    _id7z6zkg.Queue? queue,
    int? waitingCount,
    List<_i1h51zb1.Counter>? counters,
  }) {
    return QueueInfo(
      queue: queue ?? this.queue.copyWith(),
      waitingCount: waitingCount ?? this.waitingCount,
      counters: counters ?? this.counters.map((e0) => e0.copyWith()).toList(),
    );
  }
}
