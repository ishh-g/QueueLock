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
import 'queue_status.dart' as _i209jpy3;

/// A virtual queue owned by one staff user.
abstract class Queue
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Queue._({
    this.id,
    required this.slug,
    required this.name,
    required this.status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    required this.ownerId,
  }) : callTimeoutSec = callTimeoutSec ?? 180,
       lastNumber = lastNumber ?? 0,
       headSeq = headSeq ?? 0,
       headHash =
           headHash ??
           '0000000000000000000000000000000000000000000000000000000000000000',
       avgServiceSec = avgServiceSec ?? 300.0,
       sampleCount = sampleCount ?? 0;

  factory Queue({
    int? id,
    required String slug,
    required String name,
    required _i209jpy3.QueueStatus status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    required _isc.UuidValue ownerId,
  }) = _QueueImpl;

  factory Queue.fromJson(Map<String, dynamic> jsonSerialization) {
    return Queue(
      id: jsonSerialization['id'] as int?,
      slug: jsonSerialization['slug'] as String,
      name: jsonSerialization['name'] as String,
      status: _i209jpy3.QueueStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      callTimeoutSec: jsonSerialization['callTimeoutSec'] as int?,
      lastNumber: jsonSerialization['lastNumber'] as int?,
      headSeq: jsonSerialization['headSeq'] as int?,
      headHash: jsonSerialization['headHash'] as String?,
      avgServiceSec: (jsonSerialization['avgServiceSec'] as num?)?.toDouble(),
      sampleCount: jsonSerialization['sampleCount'] as int?,
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String slug;

  String name;

  _i209jpy3.QueueStatus status;

  int callTimeoutSec;

  int lastNumber;

  int headSeq;

  String headHash;

  double avgServiceSec;

  int sampleCount;

  _isc.UuidValue ownerId;

  /// Returns a shallow copy of this [Queue]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Queue copyWith({
    int? id,
    String? slug,
    String? name,
    _i209jpy3.QueueStatus? status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    _isc.UuidValue? ownerId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Queue',
      if (id != null) 'id': id,
      'slug': slug,
      'name': name,
      'status': status.toJson(),
      'callTimeoutSec': callTimeoutSec,
      'lastNumber': lastNumber,
      'headSeq': headSeq,
      'headHash': headHash,
      'avgServiceSec': avgServiceSec,
      'sampleCount': sampleCount,
      'ownerId': ownerId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Queue',
      if (id != null) 'id': id,
      'slug': slug,
      'name': name,
      'status': status.toJson(),
      'callTimeoutSec': callTimeoutSec,
      'lastNumber': lastNumber,
      'headSeq': headSeq,
      'headHash': headHash,
      'avgServiceSec': avgServiceSec,
      'sampleCount': sampleCount,
      'ownerId': ownerId.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueueImpl extends Queue {
  _QueueImpl({
    int? id,
    required String slug,
    required String name,
    required _i209jpy3.QueueStatus status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    required _isc.UuidValue ownerId,
  }) : super._(
         id: id,
         slug: slug,
         name: name,
         status: status,
         callTimeoutSec: callTimeoutSec,
         lastNumber: lastNumber,
         headSeq: headSeq,
         headHash: headHash,
         avgServiceSec: avgServiceSec,
         sampleCount: sampleCount,
         ownerId: ownerId,
       );

  /// Returns a shallow copy of this [Queue]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Queue copyWith({
    Object? id = _Undefined,
    String? slug,
    String? name,
    _i209jpy3.QueueStatus? status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    _isc.UuidValue? ownerId,
  }) {
    return Queue(
      id: id is int? ? id : this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      status: status ?? this.status,
      callTimeoutSec: callTimeoutSec ?? this.callTimeoutSec,
      lastNumber: lastNumber ?? this.lastNumber,
      headSeq: headSeq ?? this.headSeq,
      headHash: headHash ?? this.headHash,
      avgServiceSec: avgServiceSec ?? this.avgServiceSec,
      sampleCount: sampleCount ?? this.sampleCount,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
