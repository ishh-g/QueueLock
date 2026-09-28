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

/// A customer's place in a queue. Never expose tokenHash to clients.
abstract class Ticket implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      counterId: jsonSerialization['counterId'] as int?,
      servingAt: jsonSerialization['servingAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['servingAt']),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
      reentries: jsonSerialization['reentries'] as int?,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = TicketTable();

  static const db = TicketRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static TicketInclude include() {
    return TicketInclude._();
  }

  static TicketIncludeList includeList({
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    TicketInclude? include,
  }) {
    return TicketIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class TicketUpdateTable extends _is.UpdateTable<TicketTable> {
  TicketUpdateTable(super.table);

  _is.ColumnValue<int, int> queueId(int value) => _is.ColumnValue(
    table.queueId,
    value,
  );

  _is.ColumnValue<int, int> number(int value) => _is.ColumnValue(
    table.number,
    value,
  );

  _is.ColumnValue<String, String> nickname(String? value) => _is.ColumnValue(
    table.nickname,
    value,
  );

  _is.ColumnValue<String, String> tokenHash(String value) => _is.ColumnValue(
    table.tokenHash,
    value,
  );

  _is.ColumnValue<_i6gr5kxf.TicketStatus, _i6gr5kxf.TicketStatus> status(
    _i6gr5kxf.TicketStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<double, double> orderKey(double value) => _is.ColumnValue(
    table.orderKey,
    value,
  );

  _is.ColumnValue<int, int> callId(int value) => _is.ColumnValue(
    table.callId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> calledAt(DateTime? value) =>
      _is.ColumnValue(
        table.calledAt,
        value,
      );

  _is.ColumnValue<int, int> counterId(int? value) => _is.ColumnValue(
    table.counterId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> servingAt(DateTime? value) =>
      _is.ColumnValue(
        table.servingAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> doneAt(DateTime? value) =>
      _is.ColumnValue(
        table.doneAt,
        value,
      );

  _is.ColumnValue<int, int> reentries(int value) => _is.ColumnValue(
    table.reentries,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );
}

class TicketTable extends _is.Table<int?> {
  TicketTable({super.tableRelation}) : super(tableName: 'ticket') {
    updateTable = TicketUpdateTable(this);
    queueId = _is.ColumnInt(
      'queueId',
      this,
    );
    number = _is.ColumnInt(
      'number',
      this,
    );
    nickname = _is.ColumnString(
      'nickname',
      this,
    );
    tokenHash = _is.ColumnString(
      'tokenHash',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    orderKey = _is.ColumnDouble(
      'orderKey',
      this,
    );
    callId = _is.ColumnInt(
      'callId',
      this,
      hasDefault: true,
    );
    calledAt = _is.ColumnDateTime(
      'calledAt',
      this,
    );
    counterId = _is.ColumnInt(
      'counterId',
      this,
    );
    servingAt = _is.ColumnDateTime(
      'servingAt',
      this,
    );
    doneAt = _is.ColumnDateTime(
      'doneAt',
      this,
    );
    reentries = _is.ColumnInt(
      'reentries',
      this,
      hasDefault: true,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
      hasDefault: true,
    );
  }

  late final TicketUpdateTable updateTable;

  late final _is.ColumnInt queueId;

  late final _is.ColumnInt number;

  late final _is.ColumnString nickname;

  late final _is.ColumnString tokenHash;

  late final _is.ColumnEnum<_i6gr5kxf.TicketStatus> status;

  late final _is.ColumnDouble orderKey;

  late final _is.ColumnInt callId;

  late final _is.ColumnDateTime calledAt;

  late final _is.ColumnInt counterId;

  late final _is.ColumnDateTime servingAt;

  late final _is.ColumnDateTime doneAt;

  late final _is.ColumnInt reentries;

  late final _is.ColumnDateTime joinedAt;

  @override
  List<_is.Column> get columns => [
    id,
    queueId,
    number,
    nickname,
    tokenHash,
    status,
    orderKey,
    callId,
    calledAt,
    counterId,
    servingAt,
    doneAt,
    reentries,
    joinedAt,
  ];
}

class TicketInclude extends _is.IncludeObject {
  TicketInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Ticket.t;
}

class TicketIncludeList extends _is.IncludeList {
  TicketIncludeList._({
    _is.WhereExpressionBuilder<TicketTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Ticket.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Ticket.t;
}

class TicketRepository {
  const TicketRepository._();

  /// Returns a list of [Ticket]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Ticket>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Ticket>(
      where: where?.call(Ticket.t),
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Ticket] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Ticket?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Ticket>(
      where: where?.call(Ticket.t),
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Ticket] by its [id] or null if no such row exists.
  Future<Ticket?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Ticket>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Ticket]s in the list and returns the inserted rows.
  ///
  /// The returned [Ticket]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> insert(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Ticket>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Ticket] and returns the inserted row.
  ///
  /// The returned [Ticket] will have its `id` field set.
  Future<Ticket> insertRow(
    _is.DatabaseSession session,
    Ticket row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Ticket>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Ticket]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Ticket]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> upsert(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    required _is.ColumnSelections<TicketTable> conflictColumns,
    _is.ColumnSelections<TicketTable>? updateColumns,
    _is.WhereExpressionBuilder<TicketTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Ticket>(
      rows,
      conflictColumns: conflictColumns(Ticket.t),
      updateColumns: updateColumns?.call(Ticket.t),
      updateWhere: updateWhere?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Ticket] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Ticket] will have its `id` field set.
  Future<Ticket?> upsertRow(
    _is.DatabaseSession session,
    Ticket row, {
    required _is.ColumnSelections<TicketTable> conflictColumns,
    _is.ColumnSelections<TicketTable>? updateColumns,
    _is.WhereExpressionBuilder<TicketTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Ticket>(
      row,
      conflictColumns: conflictColumns(Ticket.t),
      updateColumns: updateColumns?.call(Ticket.t),
      updateWhere: updateWhere?.call(Ticket.t),
      transaction: transaction,
    );
  }

  /// Updates all [Ticket]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> update(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    _is.ColumnSelections<TicketTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Ticket>(
      rows,
      columns: columns?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Ticket]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Ticket> updateRow(
    _is.DatabaseSession session,
    Ticket row, {
    _is.ColumnSelections<TicketTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Ticket>(
      row,
      columns: columns?.call(Ticket.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Ticket] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Ticket?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TicketUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Ticket>(
      id,
      columnValues: columnValues(Ticket.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Ticket]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TicketUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TicketTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Ticket>(
      columnValues: columnValues(Ticket.t.updateTable),
      where: where(Ticket.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Ticket]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> delete(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Ticket>(
      rows,
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Ticket].
  Future<Ticket> deleteRow(
    _is.DatabaseSession session,
    Ticket row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Ticket>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TicketTable> where,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Ticket>(
      where: where(Ticket.t),
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Ticket>(
      where: where?.call(Ticket.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Ticket] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TicketTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Ticket>(
      where: where(Ticket.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
