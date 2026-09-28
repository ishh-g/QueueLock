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
import 'package:serverpod/serverpod.dart' as _is;
import 'ticket_status.dart' as _i6gr5kxf;

/// Live customer-facing view of one ticket. Recomputed server-side on
/// every queue change; the client only renders.
abstract class TicketView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TicketView._({
    required this.queueId,
    required this.queueSlug,
    required this.queueName,
    required this.number,
    this.nickname,
    required this.status,
    required this.position,
    this.etaSeconds,
    this.counterName,
    this.arriveInSec,
    this.receiptSeq,
    this.receiptHash,
  });

  factory TicketView({
    required int queueId,
    required String queueSlug,
    required String queueName,
    required int number,
    String? nickname,
    required _i6gr5kxf.TicketStatus status,
    required int position,
    int? etaSeconds,
    String? counterName,
    int? arriveInSec,
    int? receiptSeq,
    String? receiptHash,
  }) = _TicketViewImpl;

  factory TicketView.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketView(
      queueId: jsonSerialization['queueId'] as int,
      queueSlug: jsonSerialization['queueSlug'] as String,
      queueName: jsonSerialization['queueName'] as String,
      number: jsonSerialization['number'] as int,
      nickname: jsonSerialization['nickname'] as String?,
      status: _i6gr5kxf.TicketStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      position: jsonSerialization['position'] as int,
      etaSeconds: jsonSerialization['etaSeconds'] as int?,
      counterName: jsonSerialization['counterName'] as String?,
      arriveInSec: jsonSerialization['arriveInSec'] as int?,
      receiptSeq: jsonSerialization['receiptSeq'] as int?,
      receiptHash: jsonSerialization['receiptHash'] as String?,
    );
  }

  int queueId;

  String queueSlug;

  String queueName;

  int number;

  String? nickname;

  _i6gr5kxf.TicketStatus status;

  int position;

  int? etaSeconds;

  String? counterName;

  int? arriveInSec;

  int? receiptSeq;

  String? receiptHash;

  /// Returns a shallow copy of this [TicketView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TicketView copyWith({
    int? queueId,
    String? queueSlug,
    String? queueName,
    int? number,
    String? nickname,
    _i6gr5kxf.TicketStatus? status,
    int? position,
    int? etaSeconds,
    String? counterName,
    int? arriveInSec,
    int? receiptSeq,
    String? receiptHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketView',
      'queueId': queueId,
      'queueSlug': queueSlug,
      'queueName': queueName,
      'number': number,
      if (nickname != null) 'nickname': nickname,
      'status': status.toJson(),
      'position': position,
      if (etaSeconds != null) 'etaSeconds': etaSeconds,
      if (counterName != null) 'counterName': counterName,
      if (arriveInSec != null) 'arriveInSec': arriveInSec,
      if (receiptSeq != null) 'receiptSeq': receiptSeq,
      if (receiptHash != null) 'receiptHash': receiptHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TicketView',
      'queueId': queueId,
      'queueSlug': queueSlug,
      'queueName': queueName,
      'number': number,
      if (nickname != null) 'nickname': nickname,
      'status': status.toJson(),
      'position': position,
      if (etaSeconds != null) 'etaSeconds': etaSeconds,
      if (counterName != null) 'counterName': counterName,
      if (arriveInSec != null) 'arriveInSec': arriveInSec,
      if (receiptSeq != null) 'receiptSeq': receiptSeq,
      if (receiptHash != null) 'receiptHash': receiptHash,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketViewImpl extends TicketView {
  _TicketViewImpl({
    required int queueId,
    required String queueSlug,
    required String queueName,
    required int number,
    String? nickname,
    required _i6gr5kxf.TicketStatus status,
    required int position,
    int? etaSeconds,
    String? counterName,
    int? arriveInSec,
    int? receiptSeq,
    String? receiptHash,
  }) : super._(
         queueId: queueId,
         queueSlug: queueSlug,
         queueName: queueName,
         number: number,
         nickname: nickname,
         status: status,
         position: position,
         etaSeconds: etaSeconds,
         counterName: counterName,
         arriveInSec: arriveInSec,
         receiptSeq: receiptSeq,
         receiptHash: receiptHash,
       );

  /// Returns a shallow copy of this [TicketView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TicketView copyWith({
    int? queueId,
    String? queueSlug,
    String? queueName,
    int? number,
    Object? nickname = _Undefined,
    _i6gr5kxf.TicketStatus? status,
    int? position,
    Object? etaSeconds = _Undefined,
    Object? counterName = _Undefined,
    Object? arriveInSec = _Undefined,
    Object? receiptSeq = _Undefined,
    Object? receiptHash = _Undefined,
  }) {
    return TicketView(
      queueId: queueId ?? this.queueId,
      queueSlug: queueSlug ?? this.queueSlug,
      queueName: queueName ?? this.queueName,
      number: number ?? this.number,
      nickname: nickname is String? ? nickname : this.nickname,
      status: status ?? this.status,
      position: position ?? this.position,
      etaSeconds: etaSeconds is int? ? etaSeconds : this.etaSeconds,
      counterName: counterName is String? ? counterName : this.counterName,
      arriveInSec: arriveInSec is int? ? arriveInSec : this.arriveInSec,
      receiptSeq: receiptSeq is int? ? receiptSeq : this.receiptSeq,
      receiptHash: receiptHash is String? ? receiptHash : this.receiptHash,
    );
  }
}
