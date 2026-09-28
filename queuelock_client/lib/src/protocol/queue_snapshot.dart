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
import 'queue_status.dart' as _i209jpy3;
import 'ticket_public.dart' as _iyr2jrp9;

/// Live staff-facing snapshot of a queue. Recomputed server-side on
/// every queue change; the client only renders.
abstract class QueueSnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QueueSnapshot._({
    required this.queueId,
    required this.queueName,
    required this.slug,
    required this.status,
    required this.waiting,
    required this.called,
    required this.serving,
    required this.counters,
    required this.avgServiceSec,
    required this.sampleCount,
  });

  factory QueueSnapshot({
    required int queueId,
    required String queueName,
    required String slug,
    required _i209jpy3.QueueStatus status,
    required List<_iyr2jrp9.TicketPublic> waiting,
    required List<_iyr2jrp9.TicketPublic> called,
    required List<_iyr2jrp9.TicketPublic> serving,
    required List<_i1h51zb1.Counter> counters,
    required double avgServiceSec,
    required int sampleCount,
  }) = _QueueSnapshotImpl;

  factory QueueSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueSnapshot(
      queueId: jsonSerialization['queueId'] as int,
      queueName: jsonSerialization['queueName'] as String,
      slug: jsonSerialization['slug'] as String,
      status: _i209jpy3.QueueStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      waiting: _i63o5r82.Protocol().deserialize<List<_iyr2jrp9.TicketPublic>>(
        jsonSerialization['waiting'],
      ),
      called: _i63o5r82.Protocol().deserialize<List<_iyr2jrp9.TicketPublic>>(
        jsonSerialization['called'],
      ),
      serving: _i63o5r82.Protocol().deserialize<List<_iyr2jrp9.TicketPublic>>(
        jsonSerialization['serving'],
      ),
      counters: _i63o5r82.Protocol().deserialize<List<_i1h51zb1.Counter>>(
        jsonSerialization['counters'],
      ),
      avgServiceSec: (jsonSerialization['avgServiceSec'] as num).toDouble(),
      sampleCount: jsonSerialization['sampleCount'] as int,
    );
  }

  int queueId;

  String queueName;

  String slug;

  _i209jpy3.QueueStatus status;

  List<_iyr2jrp9.TicketPublic> waiting;

  List<_iyr2jrp9.TicketPublic> called;

  List<_iyr2jrp9.TicketPublic> serving;

  List<_i1h51zb1.Counter> counters;

  double avgServiceSec;

  int sampleCount;

  /// Returns a shallow copy of this [QueueSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QueueSnapshot copyWith({
    int? queueId,
    String? queueName,
    String? slug,
    _i209jpy3.QueueStatus? status,
    List<_iyr2jrp9.TicketPublic>? waiting,
    List<_iyr2jrp9.TicketPublic>? called,
    List<_iyr2jrp9.TicketPublic>? serving,
    List<_i1h51zb1.Counter>? counters,
    double? avgServiceSec,
    int? sampleCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueueSnapshot',
      'queueId': queueId,
      'queueName': queueName,
      'slug': slug,
      'status': status.toJson(),
      'waiting': waiting.toJson(valueToJson: (v) => v.toJson()),
      'called': called.toJson(valueToJson: (v) => v.toJson()),
      'serving': serving.toJson(valueToJson: (v) => v.toJson()),
      'counters': counters.toJson(valueToJson: (v) => v.toJson()),
      'avgServiceSec': avgServiceSec,
      'sampleCount': sampleCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueueSnapshot',
      'queueId': queueId,
      'queueName': queueName,
      'slug': slug,
      'status': status.toJson(),
      'waiting': waiting.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'called': called.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'serving': serving.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'counters': counters.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'avgServiceSec': avgServiceSec,
      'sampleCount': sampleCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _QueueSnapshotImpl extends QueueSnapshot {
  _QueueSnapshotImpl({
    required int queueId,
    required String queueName,
    required String slug,
    required _i209jpy3.QueueStatus status,
    required List<_iyr2jrp9.TicketPublic> waiting,
    required List<_iyr2jrp9.TicketPublic> called,
    required List<_iyr2jrp9.TicketPublic> serving,
    required List<_i1h51zb1.Counter> counters,
    required double avgServiceSec,
    required int sampleCount,
  }) : super._(
         queueId: queueId,
         queueName: queueName,
         slug: slug,
         status: status,
         waiting: waiting,
         called: called,
         serving: serving,
         counters: counters,
         avgServiceSec: avgServiceSec,
         sampleCount: sampleCount,
       );

  /// Returns a shallow copy of this [QueueSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QueueSnapshot copyWith({
    int? queueId,
    String? queueName,
    String? slug,
    _i209jpy3.QueueStatus? status,
    List<_iyr2jrp9.TicketPublic>? waiting,
    List<_iyr2jrp9.TicketPublic>? called,
    List<_iyr2jrp9.TicketPublic>? serving,
    List<_i1h51zb1.Counter>? counters,
    double? avgServiceSec,
    int? sampleCount,
  }) {
    return QueueSnapshot(
      queueId: queueId ?? this.queueId,
      queueName: queueName ?? this.queueName,
      slug: slug ?? this.slug,
      status: status ?? this.status,
      waiting: waiting ?? this.waiting.map((e0) => e0.copyWith()).toList(),
      called: called ?? this.called.map((e0) => e0.copyWith()).toList(),
      serving: serving ?? this.serving.map((e0) => e0.copyWith()).toList(),
      counters: counters ?? this.counters.map((e0) => e0.copyWith()).toList(),
      avgServiceSec: avgServiceSec ?? this.avgServiceSec,
      sampleCount: sampleCount ?? this.sampleCount,
    );
  }
}
