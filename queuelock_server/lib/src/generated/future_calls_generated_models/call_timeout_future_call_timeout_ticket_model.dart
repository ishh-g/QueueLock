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

abstract class CallTimeoutFutureCallTimeoutTicketModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CallTimeoutFutureCallTimeoutTicketModel._({
    required this.ticketId,
    required this.callId,
  });

  factory CallTimeoutFutureCallTimeoutTicketModel({
    required int ticketId,
    required int callId,
  }) = _CallTimeoutFutureCallTimeoutTicketModelImpl;

  factory CallTimeoutFutureCallTimeoutTicketModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CallTimeoutFutureCallTimeoutTicketModel(
      ticketId: jsonSerialization['ticketId'] as int,
      callId: jsonSerialization['callId'] as int,
    );
  }

  int ticketId;

  int callId;

  /// Returns a shallow copy of this [CallTimeoutFutureCallTimeoutTicketModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CallTimeoutFutureCallTimeoutTicketModel copyWith({
    int? ticketId,
    int? callId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CallTimeoutFutureCallTimeoutTicketModel',
      'ticketId': ticketId,
      'callId': callId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CallTimeoutFutureCallTimeoutTicketModelImpl
    extends CallTimeoutFutureCallTimeoutTicketModel {
  _CallTimeoutFutureCallTimeoutTicketModelImpl({
    required int ticketId,
    required int callId,
  }) : super._(
         ticketId: ticketId,
         callId: callId,
       );

  /// Returns a shallow copy of this [CallTimeoutFutureCallTimeoutTicketModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CallTimeoutFutureCallTimeoutTicketModel copyWith({
    int? ticketId,
    int? callId,
  }) {
    return CallTimeoutFutureCallTimeoutTicketModel(
      ticketId: ticketId ?? this.ticketId,
      callId: callId ?? this.callId,
    );
  }
}
