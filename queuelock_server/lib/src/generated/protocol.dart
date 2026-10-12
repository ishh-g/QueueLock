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
import 'package:queuelock_server/src/generated/ledger_entry.dart' as _iuoxbxw3;
import 'package:queuelock_server/src/generated/queue.dart' as _ix1t8flb;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'counter.dart' as _i1h51zb1;
import 'future_calls_generated_models/call_timeout_future_call_timeout_ticket_model.dart'
    as _ihp34uu4;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'join_rate_limit_hit.dart' as _ijrwl3q5;
import 'join_receipt.dart' as _i8mw49jm;
import 'ledger_entry.dart' as _ivha9tke;
import 'ledger_type.dart' as _ilcdwnij;
import 'queue.dart' as _id7z6zkg;
import 'queue_changed.dart' as _ikkr9em0;
import 'queue_error.dart' as _if4uobar;
import 'queue_info.dart' as _ivuo3aey;
import 'queue_snapshot.dart' as _izzdfuht;
import 'queue_status.dart' as _i209jpy3;
import 'service_sample.dart' as _itt33xw7;
import 'ticket.dart' as _iw5evp47;
import 'ticket_public.dart' as _iyr2jrp9;
import 'ticket_status.dart' as _i6gr5kxf;
import 'ticket_view.dart' as _iz9n3kug;
import 'verify_result.dart' as _iowd800h;
export 'counter.dart';
export 'greetings/greeting.dart';
export 'join_rate_limit_hit.dart';
export 'join_receipt.dart';
export 'ledger_entry.dart';
export 'ledger_type.dart';
export 'queue.dart';
export 'queue_changed.dart';
export 'queue_error.dart';
export 'queue_info.dart';
export 'queue_snapshot.dart';
export 'queue_status.dart';
export 'service_sample.dart';
export 'ticket.dart';
export 'ticket_public.dart';
export 'ticket_status.dart';
export 'ticket_view.dart';
export 'verify_result.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'counter',
      dartName: 'Counter',
      schema: 'public',
      module: 'queuelock',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'queueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'counter_fk_0',
          columns: ['queueId'],
          referenceTable: 'queue',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'join_rate_limit_hit',
      dartName: 'JoinRateLimitHit',
      schema: 'public',
      module: 'queuelock',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'queueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'ipHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'tsMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'join_rate_limit_lookup_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'queueId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ipHash',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tsMs',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ledger_entry',
      dartName: 'LedgerEntry',
      schema: 'public',
      module: 'queuelock',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'queueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'seq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:LedgerType',
        ),
        _isp.ColumnDefinition(
          name: 'ticketNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'counterId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'detail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'tsMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'prevHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'hash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ledger_entry_fk_0',
          columns: ['queueId'],
          referenceTable: 'queue',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ledger_entry__queueId__seq__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'queueId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'seq',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'queue',
      dartName: 'Queue',
      schema: 'public',
      module: 'queuelock',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:QueueStatus',
        ),
        _isp.ColumnDefinition(
          name: 'callTimeoutSec',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '180',
        ),
        _isp.ColumnDefinition(
          name: 'lastNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'headSeq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'headHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault:
              '\'0000000000000000000000000000000000000000000000000000000000000000\'',
        ),
        _isp.ColumnDefinition(
          name: 'avgServiceSec',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '300.0',
        ),
        _isp.ColumnDefinition(
          name: 'sampleCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'queue__slug__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'service_sample',
      dartName: 'ServiceSample',
      schema: 'public',
      module: 'queuelock',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'queueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'counterId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'hourOfDay',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'durationSec',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'service_sample_fk_0',
          columns: ['queueId'],
          referenceTable: 'queue',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ticket',
      dartName: 'Ticket',
      schema: 'public',
      module: 'queuelock',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'queueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'number',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'nickname',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'tokenHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TicketStatus',
        ),
        _isp.ColumnDefinition(
          name: 'orderKey',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'callId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'calledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'counterId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'servingAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'doneAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'reentries',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'joinedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ticket_fk_0',
          columns: ['queueId'],
          referenceTable: 'queue',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ticket__queueId__number__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'queueId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'number',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'ticket_queue_status_order_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'queueId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'orderKey',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i1h51zb1.Counter) {
      return _i1h51zb1.Counter.fromJson(data) as T;
    }
    if (t == _ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel) {
      return _ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel.fromJson(data)
          as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _ijrwl3q5.JoinRateLimitHit) {
      return _ijrwl3q5.JoinRateLimitHit.fromJson(data) as T;
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
    if (t == _ikkr9em0.QueueChanged) {
      return _ikkr9em0.QueueChanged.fromJson(data) as T;
    }
    if (t == _if4uobar.QueueError) {
      return _if4uobar.QueueError.fromJson(data) as T;
    }
    if (t == _ivuo3aey.QueueInfo) {
      return _ivuo3aey.QueueInfo.fromJson(data) as T;
    }
    if (t == _izzdfuht.QueueSnapshot) {
      return _izzdfuht.QueueSnapshot.fromJson(data) as T;
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
    if (t == _iyr2jrp9.TicketPublic) {
      return _iyr2jrp9.TicketPublic.fromJson(data) as T;
    }
    if (t == _i6gr5kxf.TicketStatus) {
      return _i6gr5kxf.TicketStatus.fromJson(data) as T;
    }
    if (t == _iz9n3kug.TicketView) {
      return _iz9n3kug.TicketView.fromJson(data) as T;
    }
    if (t == _iowd800h.VerifyResult) {
      return _iowd800h.VerifyResult.fromJson(data) as T;
    }
    if (t == _is.getType<_i1h51zb1.Counter?>()) {
      return (data != null ? _i1h51zb1.Counter.fromJson(data) : null) as T;
    }
    if (t ==
        _is.getType<_ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel?>()) {
      return (data != null
              ? _ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijrwl3q5.JoinRateLimitHit?>()) {
      return (data != null ? _ijrwl3q5.JoinRateLimitHit.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8mw49jm.JoinReceipt?>()) {
      return (data != null ? _i8mw49jm.JoinReceipt.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivha9tke.LedgerEntry?>()) {
      return (data != null ? _ivha9tke.LedgerEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilcdwnij.LedgerType?>()) {
      return (data != null ? _ilcdwnij.LedgerType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_id7z6zkg.Queue?>()) {
      return (data != null ? _id7z6zkg.Queue.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikkr9em0.QueueChanged?>()) {
      return (data != null ? _ikkr9em0.QueueChanged.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_if4uobar.QueueError?>()) {
      return (data != null ? _if4uobar.QueueError.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivuo3aey.QueueInfo?>()) {
      return (data != null ? _ivuo3aey.QueueInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izzdfuht.QueueSnapshot?>()) {
      return (data != null ? _izzdfuht.QueueSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i209jpy3.QueueStatus?>()) {
      return (data != null ? _i209jpy3.QueueStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itt33xw7.ServiceSample?>()) {
      return (data != null ? _itt33xw7.ServiceSample.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iw5evp47.Ticket?>()) {
      return (data != null ? _iw5evp47.Ticket.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyr2jrp9.TicketPublic?>()) {
      return (data != null ? _iyr2jrp9.TicketPublic.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6gr5kxf.TicketStatus?>()) {
      return (data != null ? _i6gr5kxf.TicketStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz9n3kug.TicketView?>()) {
      return (data != null ? _iz9n3kug.TicketView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iowd800h.VerifyResult?>()) {
      return (data != null ? _iowd800h.VerifyResult.fromJson(data) : null) as T;
    }
    if (t == List<_i1h51zb1.Counter>) {
      return (data as List)
              .map((e) => deserialize<_i1h51zb1.Counter>(e))
              .toList()
          as T;
    }
    if (t == List<_iyr2jrp9.TicketPublic>) {
      return (data as List)
              .map((e) => deserialize<_iyr2jrp9.TicketPublic>(e))
              .toList()
          as T;
    }
    if (t == List<_ix1t8flb.Queue>) {
      return (data as List).map((e) => deserialize<_ix1t8flb.Queue>(e)).toList()
          as T;
    }
    if (t == List<_iuoxbxw3.LedgerEntry>) {
      return (data as List)
              .map((e) => deserialize<_iuoxbxw3.LedgerEntry>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i1h51zb1.Counter => 'Counter',
      _ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel =>
        'CallTimeoutFutureCallTimeoutTicketModel',
      _izw8z7ou.Greeting => 'Greeting',
      _ijrwl3q5.JoinRateLimitHit => 'JoinRateLimitHit',
      _i8mw49jm.JoinReceipt => 'JoinReceipt',
      _ivha9tke.LedgerEntry => 'LedgerEntry',
      _ilcdwnij.LedgerType => 'LedgerType',
      _id7z6zkg.Queue => 'Queue',
      _ikkr9em0.QueueChanged => 'QueueChanged',
      _if4uobar.QueueError => 'QueueError',
      _ivuo3aey.QueueInfo => 'QueueInfo',
      _izzdfuht.QueueSnapshot => 'QueueSnapshot',
      _i209jpy3.QueueStatus => 'QueueStatus',
      _itt33xw7.ServiceSample => 'ServiceSample',
      _iw5evp47.Ticket => 'Ticket',
      _iyr2jrp9.TicketPublic => 'TicketPublic',
      _i6gr5kxf.TicketStatus => 'TicketStatus',
      _iz9n3kug.TicketView => 'TicketView',
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
      case _ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel():
        return 'CallTimeoutFutureCallTimeoutTicketModel';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _ijrwl3q5.JoinRateLimitHit():
        return 'JoinRateLimitHit';
      case _i8mw49jm.JoinReceipt():
        return 'JoinReceipt';
      case _ivha9tke.LedgerEntry():
        return 'LedgerEntry';
      case _ilcdwnij.LedgerType():
        return 'LedgerType';
      case _id7z6zkg.Queue():
        return 'Queue';
      case _ikkr9em0.QueueChanged():
        return 'QueueChanged';
      case _if4uobar.QueueError():
        return 'QueueError';
      case _ivuo3aey.QueueInfo():
        return 'QueueInfo';
      case _izzdfuht.QueueSnapshot():
        return 'QueueSnapshot';
      case _i209jpy3.QueueStatus():
        return 'QueueStatus';
      case _itt33xw7.ServiceSample():
        return 'ServiceSample';
      case _iw5evp47.Ticket():
        return 'Ticket';
      case _iyr2jrp9.TicketPublic():
        return 'TicketPublic';
      case _i6gr5kxf.TicketStatus():
        return 'TicketStatus';
      case _iz9n3kug.TicketView():
        return 'TicketView';
      case _iowd800h.VerifyResult():
        return 'VerifyResult';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'CallTimeoutFutureCallTimeoutTicketModel') {
      return deserialize<_ihp34uu4.CallTimeoutFutureCallTimeoutTicketModel>(
        data['data'],
      );
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'JoinRateLimitHit') {
      return deserialize<_ijrwl3q5.JoinRateLimitHit>(data['data']);
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
    if (dataClassName == 'QueueChanged') {
      return deserialize<_ikkr9em0.QueueChanged>(data['data']);
    }
    if (dataClassName == 'QueueError') {
      return deserialize<_if4uobar.QueueError>(data['data']);
    }
    if (dataClassName == 'QueueInfo') {
      return deserialize<_ivuo3aey.QueueInfo>(data['data']);
    }
    if (dataClassName == 'QueueSnapshot') {
      return deserialize<_izzdfuht.QueueSnapshot>(data['data']);
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
    if (dataClassName == 'TicketPublic') {
      return deserialize<_iyr2jrp9.TicketPublic>(data['data']);
    }
    if (dataClassName == 'TicketStatus') {
      return deserialize<_i6gr5kxf.TicketStatus>(data['data']);
    }
    if (dataClassName == 'TicketView') {
      return deserialize<_iz9n3kug.TicketView>(data['data']);
    }
    if (dataClassName == 'VerifyResult') {
      return deserialize<_iowd800h.VerifyResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('queuelock', this);
    _iacs.Protocol().registerHostProtocol('queuelock', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i1h51zb1.Counter:
        return _i1h51zb1.Counter.t;
      case _ijrwl3q5.JoinRateLimitHit:
        return _ijrwl3q5.JoinRateLimitHit.t;
      case _ivha9tke.LedgerEntry:
        return _ivha9tke.LedgerEntry.t;
      case _id7z6zkg.Queue:
        return _id7z6zkg.Queue.t;
      case _itt33xw7.ServiceSample:
        return _itt33xw7.ServiceSample.t;
      case _iw5evp47.Ticket:
        return _iw5evp47.Ticket.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
