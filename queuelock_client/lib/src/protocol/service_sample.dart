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

/// One observed service duration, used by the wait-time estimator.
abstract class ServiceSample
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ServiceSample._({
    this.id,
    required this.queueId,
    this.counterId,
    required this.hourOfDay,
    required this.durationSec,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ServiceSample({
    int? id,
    required int queueId,
    int? counterId,
    required int hourOfDay,
    required double durationSec,
    DateTime? createdAt,
  }) = _ServiceSampleImpl;

  factory ServiceSample.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceSample(
      id: jsonSerialization['id'] as int?,
      queueId: jsonSerialization['queueId'] as int,
      counterId: jsonSerialization['counterId'] as int?,
      hourOfDay: jsonSerialization['hourOfDay'] as int,
      durationSec: (jsonSerialization['durationSec'] as num).toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int queueId;

  int? counterId;

  int hourOfDay;

  double durationSec;

  DateTime createdAt;

  /// Returns a shallow copy of this [ServiceSample]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ServiceSample copyWith({
    int? id,
    int? queueId,
    int? counterId,
    int? hourOfDay,
    double? durationSec,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceSample',
      if (id != null) 'id': id,
      'queueId': queueId,
      if (counterId != null) 'counterId': counterId,
      'hourOfDay': hourOfDay,
      'durationSec': durationSec,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServiceSample',
      if (id != null) 'id': id,
      'queueId': queueId,
      if (counterId != null) 'counterId': counterId,
      'hourOfDay': hourOfDay,
      'durationSec': durationSec,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceSampleImpl extends ServiceSample {
  _ServiceSampleImpl({
    int? id,
    required int queueId,
    int? counterId,
    required int hourOfDay,
    required double durationSec,
    DateTime? createdAt,
  }) : super._(
         id: id,
         queueId: queueId,
         counterId: counterId,
         hourOfDay: hourOfDay,
         durationSec: durationSec,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ServiceSample]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ServiceSample copyWith({
    Object? id = _Undefined,
    int? queueId,
    Object? counterId = _Undefined,
    int? hourOfDay,
    double? durationSec,
    DateTime? createdAt,
  }) {
    return ServiceSample(
      id: id is int? ? id : this.id,
      queueId: queueId ?? this.queueId,
      counterId: counterId is int? ? counterId : this.counterId,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      durationSec: durationSec ?? this.durationSec,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
