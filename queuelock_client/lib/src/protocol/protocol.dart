/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:queuelock_client/src/protocol/ledger_entry.dart' as _ioekpgt9;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'counter.dart' as _i1h51zb1;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'join_receipt.dart' as _i8mw49jm;
import 'ledger_entry.dart' as _ivha9tke;
import 'ledger_type.dart' as _ilcdwnij;
import 'queue.dart' as _id7z6zkg;
import 'queue_error.dart' as _if4uobar;
import 'queue_info.dart' as _ivuo3aey;
import 'queue_status.dart' as _i209jpy3;
import 'service_sample.dart' as _itt33xw7;
import 'ticket.dart' as _iw5evp47;
import 'ticket_status.dart' as _i6gr5kxf;
import 'verify_result.dart' as _iowd800h;
export 'counter.dart';
export 'greetings/greeting.dart';
export 'join_receipt.dart';
export 'ledger_entry.dart';
export 'ledger_type.dart';
export 'queue.dart';
export 'queue_error.dart';
export 'queue_info.dart';
export 'queue_status.dart';
export 'service_sample.dart';
export 'ticket.dart';
export 'ticket_status.dart';
export 'verify_result.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i1h51zb1.Counter) {
      return _i1h51zb1.Counter.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i8mw49jm.JoinReceipt) {
      return _i8mw49jm.JoinReceipt.fromJson(data) as T;
    }
    if (t == _ivha9tke.LedgerEntry) {
      return _ivha9tke.LedgerEntry.fromJson(data) as T;
    }
    if (t == _ilcdwnij.LedgerType) {
      return _ilcdwnij.LedgerType.fromJson(data) as T;
    }
    if (t == _id7z6zkg.Queue) {
      return _id7z6zkg.Queue.fromJson(data) as T;
    }
    if (t == _if4uobar.QueueError) {
      return _if4uobar.QueueError.fromJson(data) as T;
    }
    if (t == _ivuo3aey.QueueInfo) {
      return _ivuo3aey.QueueInfo.fromJson(data) as T;
    }
    if (t == _i209jpy3.QueueStatus) {
      return _i209jpy3.QueueStatus.fromJson(data) as T;
    }
    if (t == _itt33xw7.ServiceSample) {
      return _itt33xw7.ServiceSample.fromJson(data) as T;
    }
    if (t == _iw5evp47.Ticket) {
      return _iw5evp47.Ticket.fromJson(data) as T;
    }
    if (t == _i6gr5kxf.TicketStatus) {
      return _i6gr5kxf.TicketStatus.fromJson(data) as T;
    }
    if (t == _iowd800h.VerifyResult) {
      return _iowd800h.VerifyResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_i1h51zb1.Counter?>()) {
      return (data != null ? _i1h51zb1.Counter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8mw49jm.JoinReceipt?>()) {
      return (data != null ? _i8mw49jm.JoinReceipt.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivha9tke.LedgerEntry?>()) {
      return (data != null ? _ivha9tke.LedgerEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilcdwnij.LedgerType?>()) {
      return (data != null ? _ilcdwnij.LedgerType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_id7z6zkg.Queue?>()) {
      return (data != null ? _id7z6zkg.Queue.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_if4uobar.QueueError?>()) {
      return (data != null ? _if4uobar.QueueError.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivuo3aey.QueueInfo?>()) {
      return (data != null ? _ivuo3aey.QueueInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i209jpy3.QueueStatus?>()) {
      return (data != null ? _i209jpy3.QueueStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itt33xw7.ServiceSample?>()) {
      return (data != null ? _itt33xw7.ServiceSample.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iw5evp47.Ticket?>()) {
      return (data != null ? _iw5evp47.Ticket.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6gr5kxf.TicketStatus?>()) {
      return (data != null ? _i6gr5kxf.TicketStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iowd800h.VerifyResult?>()) {
      return (data != null ? _iowd800h.VerifyResult.fromJson(data) : null) as T;
    }
    if (t == List<_i1h51zb1.Counter>) {
      return (data as List)
              .map((e) => deserialize<_i1h51zb1.Counter>(e))
              .toList()
          as T;
    }
    if (t == List<_ioekpgt9.LedgerEntry>) {
      return (data as List)
              .map((e) => deserialize<_ioekpgt9.LedgerEntry>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i1h51zb1.Counter => 'Counter',
      _izw8z7ou.Greeting => 'Greeting',
      _i8mw49jm.JoinReceipt => 'JoinReceipt',
      _ivha9tke.LedgerEntry => 'LedgerEntry',
      _ilcdwnij.LedgerType => 'LedgerType',
      _id7z6zkg.Queue => 'Queue',
      _if4uobar.QueueError => 'QueueError',
      _ivuo3aey.QueueInfo => 'QueueInfo',
      _i209jpy3.QueueStatus => 'QueueStatus',
      _itt33xw7.ServiceSample => 'ServiceSample',
      _iw5evp47.Ticket => 'Ticket',
      _i6gr5kxf.TicketStatus => 'TicketStatus',
      _iowd800h.VerifyResult => 'VerifyResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('queuelock.', '');
    }

    switch (data) {
      case _i1h51zb1.Counter():
        return 'Counter';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i8mw49jm.JoinReceipt():
        return 'JoinReceipt';
      case _ivha9tke.LedgerEntry():
        return 'LedgerEntry';
      case _ilcdwnij.LedgerType():
        return 'LedgerType';
      case _id7z6zkg.Queue():
        return 'Queue';
      case _if4uobar.QueueError():
        return 'QueueError';
      case _ivuo3aey.QueueInfo():
        return 'QueueInfo';
      case _i209jpy3.QueueStatus():
        return 'QueueStatus';
      case _itt33xw7.ServiceSample():
        return 'ServiceSample';
      case _iw5evp47.Ticket():
        return 'Ticket';
      case _i6gr5kxf.TicketStatus():
        return 'TicketStatus';
      case _iowd800h.VerifyResult():
        return 'VerifyResult';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Counter') {
      return deserialize<_i1h51zb1.Counter>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'JoinReceipt') {
      return deserialize<_i8mw49jm.JoinReceipt>(data['data']);
    }
    if (dataClassName == 'LedgerEntry') {
      return deserialize<_ivha9tke.LedgerEntry>(data['data']);
    }
    if (dataClassName == 'LedgerType') {
      return deserialize<_ilcdwnij.LedgerType>(data['data']);
    }
    if (dataClassName == 'Queue') {
      return deserialize<_id7z6zkg.Queue>(data['data']);
    }
    if (dataClassName == 'QueueError') {
      return deserialize<_if4uobar.QueueError>(data['data']);
    }
    if (dataClassName == 'QueueInfo') {
      return deserialize<_ivuo3aey.QueueInfo>(data['data']);
    }
    if (dataClassName == 'QueueStatus') {
      return deserialize<_i209jpy3.QueueStatus>(data['data']);
    }
    if (dataClassName == 'ServiceSample') {
      return deserialize<_itt33xw7.ServiceSample>(data['data']);
    }
    if (dataClassName == 'Ticket') {
      return deserialize<_iw5evp47.Ticket>(data['data']);
    }
    if (dataClassName == 'TicketStatus') {
      return deserialize<_i6gr5kxf.TicketStatus>(data['data']);
    }
    if (dataClassName == 'VerifyResult') {
      return deserialize<_iowd800h.VerifyResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('queuelock', this);
    _iacc.Protocol().registerHostProtocol('queuelock', this);
  }

  @override
  String getModuleName() => 'queuelock';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
