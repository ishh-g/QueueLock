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

/// Result of recomputing a queue's ledger chain.
abstract class VerifyResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  VerifyResult._({
    required this.ok,
    required this.entryCount,
    this.firstBadSeq,
  });

  factory VerifyResult({
    required bool ok,
    required int entryCount,
    int? firstBadSeq,
  }) = _VerifyResultImpl;

  factory VerifyResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerifyResult(
      ok: _is.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      entryCount: jsonSerialization['entryCount'] as int,
      firstBadSeq: jsonSerialization['firstBadSeq'] as int?,
    );
  }

  bool ok;

  int entryCount;

  int? firstBadSeq;

  /// Returns a shallow copy of this [VerifyResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VerifyResult copyWith({
    bool? ok,
    int? entryCount,
    int? firstBadSeq,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerifyResult',
      'ok': ok,
      'entryCount': entryCount,
      if (firstBadSeq != null) 'firstBadSeq': firstBadSeq,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerifyResult',
      'ok': ok,
      'entryCount': entryCount,
      if (firstBadSeq != null) 'firstBadSeq': firstBadSeq,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerifyResultImpl extends VerifyResult {
  _VerifyResultImpl({
    required bool ok,
    required int entryCount,
    int? firstBadSeq,
  }) : super._(
         ok: ok,
         entryCount: entryCount,
         firstBadSeq: firstBadSeq,
       );

  /// Returns a shallow copy of this [VerifyResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VerifyResult copyWith({
    bool? ok,
    int? entryCount,
    Object? firstBadSeq = _Undefined,
  }) {
    return VerifyResult(
      ok: ok ?? this.ok,
      entryCount: entryCount ?? this.entryCount,
      firstBadSeq: firstBadSeq is int? ? firstBadSeq : this.firstBadSeq,
    );
  }
}
