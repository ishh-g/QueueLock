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

/// Receipt handed to a customer on join. The token is shown once.
abstract class JoinReceipt
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JoinReceipt._({
    required this.number,
    required this.token,
    required this.joinSeq,
    required this.joinHash,
  });

  factory JoinReceipt({
    required int number,
    required String token,
    required int joinSeq,
    required String joinHash,
  }) = _JoinReceiptImpl;

  factory JoinReceipt.fromJson(Map<String, dynamic> jsonSerialization) {
    return JoinReceipt(
      number: jsonSerialization['number'] as int,
      token: jsonSerialization['token'] as String,
      joinSeq: jsonSerialization['joinSeq'] as int,
      joinHash: jsonSerialization['joinHash'] as String,
    );
  }

  int number;

  String token;

  int joinSeq;

  String joinHash;

  /// Returns a shallow copy of this [JoinReceipt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JoinReceipt copyWith({
    int? number,
    String? token,
    int? joinSeq,
    String? joinHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JoinReceipt',
      'number': number,
      'token': token,
      'joinSeq': joinSeq,
      'joinHash': joinHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JoinReceipt',
      'number': number,
      'token': token,
      'joinSeq': joinSeq,
      'joinHash': joinHash,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _JoinReceiptImpl extends JoinReceipt {
  _JoinReceiptImpl({
    required int number,
    required String token,
    required int joinSeq,
    required String joinHash,
  }) : super._(
         number: number,
         token: token,
         joinSeq: joinSeq,
         joinHash: joinHash,
       );

  /// Returns a shallow copy of this [JoinReceipt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JoinReceipt copyWith({
    int? number,
    String? token,
    int? joinSeq,
    String? joinHash,
  }) {
    return JoinReceipt(
      number: number ?? this.number,
      token: token ?? this.token,
      joinSeq: joinSeq ?? this.joinSeq,
      joinHash: joinHash ?? this.joinHash,
    );
  }
}
