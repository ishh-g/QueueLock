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

/// A customer's place in a queue. Never expose tokenHash to clients.
abstract class Ticket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Ticket._({
    this.id,
    required this.queueId,
    required this.number,
    this.nickname,
    required this.tokenHash,
    required this.status,
    required this.orderKey,
    int? callId,
    this.calledAt,
    this.counterId,
    this.servingAt,
    this.doneAt,
    int? reentries,
    DateTime? joinedAt,
  }) : callId = callId ?? 0,
       reentries = reentries ?? 0,
       joinedAt = joinedAt ?? DateTime.now();

  factory Ticket({
    int? id,
    required int queueId,
    required int number,
    String? nickname,
    required String tokenHash,
    required _i6gr5kxf.TicketStatus status,
    required double orderKey,
    int? callId,
    DateTime? calledAt,
    int? counterId,
    DateTime? servingAt,
    DateTime? doneAt,
    int? reentries,
    DateTime? joinedAt,
  }) = _TicketImpl;

  factory Ticket.fromJson(Map<String, dynamic> jsonSerialization) {
    return Ticket(
      id: jsonSerialization['id'] as int?,
      queueId: jsonSerialization['queueId'] as int,
      number: jsonSerialization['number'] as int,
      nickname: jsonSerialization['nickname'] as String?,
      tokenHash: jsonSerialization['tokenHash'] as String,
      status: _i6gr5kxf.TicketStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      orderKey: (jsonSerialization['orderKey'] as num).toDouble(),
      callId: jsonSerialization['callId'] as int?,
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      counterId: jsonSerialization['counterId'] as int?,
      servingAt: jsonSerialization['servingAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['servingAt']),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
      reentries: jsonSerialization['reentries'] as int?,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int queueId;

  int number;

  String? nickname;

  String tokenHash;

  _i6gr5kxf.TicketStatus status;

  double orderKey;

  int callId;

  DateTime? calledAt;

  int? counterId;

  DateTime? servingAt;

  DateTime? doneAt;

  int reentries;

  DateTime joinedAt;

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Ticket copyWith({
    int? id,
    int? queueId,
    int? number,
    String? nickname,
    String? tokenHash,
    _i6gr5kxf.TicketStatus? status,
    double? orderKey,
    int? callId,
    DateTime? calledAt,
    int? counterId,
    DateTime? servingAt,
    DateTime? doneAt,
    int? reentries,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Ticket',
      if (id != null) 'id': id,
      'queueId': queueId,
      'number': number,
      if (nickname != null) 'nickname': nickname,
      'tokenHash': tokenHash,
      'status': status.toJson(),
      'orderKey': orderKey,
      'callId': callId,
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (counterId != null) 'counterId': counterId,
      if (servingAt != null) 'servingAt': servingAt?.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      'reentries': reentries,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Ticket',
      if (id != null) 'id': id,
      'queueId': queueId,
      'number': number,
      if (nickname != null) 'nickname': nickname,
      'tokenHash': tokenHash,
      'status': status.toJson(),
      'orderKey': orderKey,
      'callId': callId,
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (counterId != null) 'counterId': counterId,
      if (servingAt != null) 'servingAt': servingAt?.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      'reentries': reentries,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketImpl extends Ticket {
  _TicketImpl({
    int? id,
    required int queueId,
    required int number,
    String? nickname,
    required String tokenHash,
    required _i6gr5kxf.TicketStatus status,
    required double orderKey,
    int? callId,
    DateTime? calledAt,
    int? counterId,
    DateTime? servingAt,
    DateTime? doneAt,
    int? reentries,
    DateTime? joinedAt,
  }) : super._(
         id: id,
         queueId: queueId,
         number: number,
         nickname: nickname,
         tokenHash: tokenHash,
         status: status,
         orderKey: orderKey,
         callId: callId,
         calledAt: calledAt,
         counterId: counterId,
         servingAt: servingAt,
         doneAt: doneAt,
         reentries: reentries,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Ticket copyWith({
    Object? id = _Undefined,
    int? queueId,
    int? number,
    Object? nickname = _Undefined,
    String? tokenHash,
    _i6gr5kxf.TicketStatus? status,
    double? orderKey,
    int? callId,
    Object? calledAt = _Undefined,
    Object? counterId = _Undefined,
    Object? servingAt = _Undefined,
    Object? doneAt = _Undefined,
    int? reentries,
    DateTime? joinedAt,
  }) {
    return Ticket(
      id: id is int? ? id : this.id,
      queueId: queueId ?? this.queueId,
      number: number ?? this.number,
      nickname: nickname is String? ? nickname : this.nickname,
      tokenHash: tokenHash ?? this.tokenHash,
      status: status ?? this.status,
      orderKey: orderKey ?? this.orderKey,
      callId: callId ?? this.callId,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      counterId: counterId is int? ? counterId : this.counterId,
      servingAt: servingAt is DateTime? ? servingAt : this.servingAt,
      doneAt: doneAt is DateTime? ? doneAt : this.doneAt,
      reentries: reentries ?? this.reentries,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
