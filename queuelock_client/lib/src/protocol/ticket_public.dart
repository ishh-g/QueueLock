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
import 'ticket_status.dart' as _i6gr5kxf;

/// Staff-facing ticket row. Never carries the token hash.
abstract class TicketPublic
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TicketPublic._({
    required this.id,
    required this.number,
    this.nickname,
    required this.status,
    this.counterName,
    this.calledAt,
    this.servingAt,
  });

  factory TicketPublic({
    required int id,
    required int number,
    String? nickname,
    required _i6gr5kxf.TicketStatus status,
    String? counterName,
    DateTime? calledAt,
    DateTime? servingAt,
  }) = _TicketPublicImpl;

  factory TicketPublic.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketPublic(
      id: jsonSerialization['id'] as int,
      number: jsonSerialization['number'] as int,
      nickname: jsonSerialization['nickname'] as String?,
      status: _i6gr5kxf.TicketStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      counterName: jsonSerialization['counterName'] as String?,
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      servingAt: jsonSerialization['servingAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['servingAt']),
    );
  }

  int id;

  int number;

  String? nickname;

  _i6gr5kxf.TicketStatus status;

  String? counterName;

  DateTime? calledAt;

  DateTime? servingAt;

  /// Returns a shallow copy of this [TicketPublic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TicketPublic copyWith({
    int? id,
    int? number,
    String? nickname,
    _i6gr5kxf.TicketStatus? status,
    String? counterName,
    DateTime? calledAt,
    DateTime? servingAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketPublic',
      'id': id,
      'number': number,
      if (nickname != null) 'nickname': nickname,
      'status': status.toJson(),
      if (counterName != null) 'counterName': counterName,
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (servingAt != null) 'servingAt': servingAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TicketPublic',
      'id': id,
      'number': number,
      if (nickname != null) 'nickname': nickname,
      'status': status.toJson(),
      if (counterName != null) 'counterName': counterName,
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (servingAt != null) 'servingAt': servingAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketPublicImpl extends TicketPublic {
  _TicketPublicImpl({
    required int id,
    required int number,
    String? nickname,
    required _i6gr5kxf.TicketStatus status,
    String? counterName,
    DateTime? calledAt,
    DateTime? servingAt,
  }) : super._(
         id: id,
         number: number,
         nickname: nickname,
         status: status,
         counterName: counterName,
         calledAt: calledAt,
         servingAt: servingAt,
       );

  /// Returns a shallow copy of this [TicketPublic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TicketPublic copyWith({
    int? id,
    int? number,
    Object? nickname = _Undefined,
    _i6gr5kxf.TicketStatus? status,
    Object? counterName = _Undefined,
    Object? calledAt = _Undefined,
    Object? servingAt = _Undefined,
  }) {
    return TicketPublic(
      id: id ?? this.id,
      number: number ?? this.number,
      nickname: nickname is String? ? nickname : this.nickname,
      status: status ?? this.status,
      counterName: counterName is String? ? counterName : this.counterName,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      servingAt: servingAt is DateTime? ? servingAt : this.servingAt,
    );
  }
}
