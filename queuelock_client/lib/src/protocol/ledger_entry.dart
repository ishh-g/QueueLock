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
import 'ledger_type.dart' as _ilcdwnij;

/// One entry of a queue's tamper-evident ledger. Never stores nicknames.
abstract class LedgerEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LedgerEntry._({
    this.id,
    required this.queueId,
    required this.seq,
    required this.type,
    this.ticketNumber,
    this.counterId,
    this.detail,
    required this.tsMs,
    required this.prevHash,
    required this.hash,
  });

  factory LedgerEntry({
    int? id,
    required int queueId,
    required int seq,
    required _ilcdwnij.LedgerType type,
    int? ticketNumber,
    int? counterId,
    String? detail,
    required int tsMs,
    required String prevHash,
    required String hash,
  }) = _LedgerEntryImpl;

  factory LedgerEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LedgerEntry(
      id: jsonSerialization['id'] as int?,
      queueId: jsonSerialization['queueId'] as int,
      seq: jsonSerialization['seq'] as int,
      type: _ilcdwnij.LedgerType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      ticketNumber: jsonSerialization['ticketNumber'] as int?,
      counterId: jsonSerialization['counterId'] as int?,
      detail: jsonSerialization['detail'] as String?,
      tsMs: jsonSerialization['tsMs'] as int,
      prevHash: jsonSerialization['prevHash'] as String,
      hash: jsonSerialization['hash'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int queueId;

  int seq;

  _ilcdwnij.LedgerType type;

  int? ticketNumber;

  int? counterId;

  String? detail;

  int tsMs;

  String prevHash;

  String hash;

  /// Returns a shallow copy of this [LedgerEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LedgerEntry copyWith({
    int? id,
    int? queueId,
    int? seq,
    _ilcdwnij.LedgerType? type,
    int? ticketNumber,
    int? counterId,
    String? detail,
    int? tsMs,
    String? prevHash,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LedgerEntry',
      if (id != null) 'id': id,
      'queueId': queueId,
      'seq': seq,
      'type': type.toJson(),
      if (ticketNumber != null) 'ticketNumber': ticketNumber,
      if (counterId != null) 'counterId': counterId,
      if (detail != null) 'detail': detail,
      'tsMs': tsMs,
      'prevHash': prevHash,
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LedgerEntry',
      if (id != null) 'id': id,
      'queueId': queueId,
      'seq': seq,
      'type': type.toJson(),
      if (ticketNumber != null) 'ticketNumber': ticketNumber,
      if (counterId != null) 'counterId': counterId,
      if (detail != null) 'detail': detail,
      'tsMs': tsMs,
      'prevHash': prevHash,
      'hash': hash,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LedgerEntryImpl extends LedgerEntry {
  _LedgerEntryImpl({
    int? id,
    required int queueId,
    required int seq,
    required _ilcdwnij.LedgerType type,
    int? ticketNumber,
    int? counterId,
    String? detail,
    required int tsMs,
    required String prevHash,
    required String hash,
  }) : super._(
         id: id,
         queueId: queueId,
         seq: seq,
         type: type,
         ticketNumber: ticketNumber,
         counterId: counterId,
         detail: detail,
         tsMs: tsMs,
         prevHash: prevHash,
         hash: hash,
       );

  /// Returns a shallow copy of this [LedgerEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LedgerEntry copyWith({
    Object? id = _Undefined,
    int? queueId,
    int? seq,
    _ilcdwnij.LedgerType? type,
    Object? ticketNumber = _Undefined,
    Object? counterId = _Undefined,
    Object? detail = _Undefined,
    int? tsMs,
    String? prevHash,
    String? hash,
  }) {
    return LedgerEntry(
      id: id is int? ? id : this.id,
      queueId: queueId ?? this.queueId,
      seq: seq ?? this.seq,
      type: type ?? this.type,
      ticketNumber: ticketNumber is int? ? ticketNumber : this.ticketNumber,
      counterId: counterId is int? ? counterId : this.counterId,
      detail: detail is String? ? detail : this.detail,
      tsMs: tsMs ?? this.tsMs,
      prevHash: prevHash ?? this.prevHash,
      hash: hash ?? this.hash,
    );
  }
}
