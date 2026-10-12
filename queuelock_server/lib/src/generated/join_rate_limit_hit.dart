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

/// One counted join for abuse protection. Stores only a hash of the
/// caller address, never the address itself. Rows older than a minute
/// are pruned by the sweeper.
abstract class JoinRateLimitHit
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  JoinRateLimitHit._({
    this.id,
    required this.queueId,
    required this.ipHash,
    required this.tsMs,
  });

  factory JoinRateLimitHit({
    int? id,
    required int queueId,
    required String ipHash,
    required int tsMs,
  }) = _JoinRateLimitHitImpl;

  factory JoinRateLimitHit.fromJson(Map<String, dynamic> jsonSerialization) {
    return JoinRateLimitHit(
      id: jsonSerialization['id'] as int?,
      queueId: jsonSerialization['queueId'] as int,
      ipHash: jsonSerialization['ipHash'] as String,
      tsMs: jsonSerialization['tsMs'] as int,
    );
  }

  static final t = JoinRateLimitHitTable();

  static const db = JoinRateLimitHitRepository._();

  @override
  int? id;

  int queueId;

  String ipHash;

  int tsMs;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [JoinRateLimitHit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JoinRateLimitHit copyWith({
    int? id,
    int? queueId,
    String? ipHash,
    int? tsMs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JoinRateLimitHit',
      if (id != null) 'id': id,
      'queueId': queueId,
      'ipHash': ipHash,
      'tsMs': tsMs,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JoinRateLimitHit',
      if (id != null) 'id': id,
      'queueId': queueId,
      'ipHash': ipHash,
      'tsMs': tsMs,
    };
  }

  static JoinRateLimitHitInclude include() {
    return JoinRateLimitHitInclude._();
  }

  static JoinRateLimitHitIncludeList includeList({
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JoinRateLimitHitTable>? orderBy,
    _is.OrderByListBuilder<JoinRateLimitHitTable>? orderByList,
    JoinRateLimitHitInclude? include,
  }) {
    return JoinRateLimitHitIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JoinRateLimitHit.t),
      orderByList: orderByList?.call(JoinRateLimitHit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JoinRateLimitHitImpl extends JoinRateLimitHit {
  _JoinRateLimitHitImpl({
    int? id,
    required int queueId,
    required String ipHash,
    required int tsMs,
  }) : super._(
         id: id,
         queueId: queueId,
         ipHash: ipHash,
         tsMs: tsMs,
       );

  /// Returns a shallow copy of this [JoinRateLimitHit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JoinRateLimitHit copyWith({
    Object? id = _Undefined,
    int? queueId,
    String? ipHash,
    int? tsMs,
  }) {
    return JoinRateLimitHit(
      id: id is int? ? id : this.id,
      queueId: queueId ?? this.queueId,
      ipHash: ipHash ?? this.ipHash,
      tsMs: tsMs ?? this.tsMs,
    );
  }
}

class JoinRateLimitHitUpdateTable
    extends _is.UpdateTable<JoinRateLimitHitTable> {
  JoinRateLimitHitUpdateTable(super.table);

  _is.ColumnValue<int, int> queueId(int value) => _is.ColumnValue(
    table.queueId,
    value,
  );

  _is.ColumnValue<String, String> ipHash(String value) => _is.ColumnValue(
    table.ipHash,
    value,
  );

  _is.ColumnValue<int, int> tsMs(int value) => _is.ColumnValue(
    table.tsMs,
    value,
  );
}

class JoinRateLimitHitTable extends _is.Table<int?> {
  JoinRateLimitHitTable({super.tableRelation})
    : super(tableName: 'join_rate_limit_hit') {
    updateTable = JoinRateLimitHitUpdateTable(this);
    queueId = _is.ColumnInt(
      'queueId',
      this,
    );
    ipHash = _is.ColumnString(
      'ipHash',
      this,
    );
    tsMs = _is.ColumnInt(
      'tsMs',
      this,
    );
  }

  late final JoinRateLimitHitUpdateTable updateTable;

  late final _is.ColumnInt queueId;

  late final _is.ColumnString ipHash;

  late final _is.ColumnInt tsMs;

  @override
  List<_is.Column> get columns => [
    id,
    queueId,
    ipHash,
    tsMs,
  ];
}

class JoinRateLimitHitInclude extends _is.IncludeObject {
  JoinRateLimitHitInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => JoinRateLimitHit.t;
}

class JoinRateLimitHitIncludeList extends _is.IncludeList {
  JoinRateLimitHitIncludeList._({
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JoinRateLimitHit.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => JoinRateLimitHit.t;
}

class JoinRateLimitHitRepository {
  const JoinRateLimitHitRepository._();

  /// Returns a list of [JoinRateLimitHit]s matching the given query parameters.
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
  Future<List<JoinRateLimitHit>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JoinRateLimitHitTable>? orderBy,
    _is.OrderByListBuilder<JoinRateLimitHitTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<JoinRateLimitHit>(
      where: where?.call(JoinRateLimitHit.t),
      orderBy: orderBy?.call(JoinRateLimitHit.t),
      orderByList: orderByList?.call(JoinRateLimitHit.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [JoinRateLimitHit] matching the given query parameters.
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
  Future<JoinRateLimitHit?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? where,
    int? offset,
    _is.OrderByBuilder<JoinRateLimitHitTable>? orderBy,
    _is.OrderByListBuilder<JoinRateLimitHitTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<JoinRateLimitHit>(
      where: where?.call(JoinRateLimitHit.t),
      orderBy: orderBy?.call(JoinRateLimitHit.t),
      orderByList: orderByList?.call(JoinRateLimitHit.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [JoinRateLimitHit] by its [id] or null if no such row exists.
  Future<JoinRateLimitHit?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<JoinRateLimitHit>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [JoinRateLimitHit]s in the list and returns the inserted rows.
  ///
  /// The returned [JoinRateLimitHit]s will have their `id` fields set.
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
  Future<List<JoinRateLimitHit>> insert(
    _is.DatabaseSession session,
    List<JoinRateLimitHit> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<JoinRateLimitHit>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [JoinRateLimitHit] and returns the inserted row.
  ///
  /// The returned [JoinRateLimitHit] will have its `id` field set.
  Future<JoinRateLimitHit> insertRow(
    _is.DatabaseSession session,
    JoinRateLimitHit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<JoinRateLimitHit>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [JoinRateLimitHit]s in the list and returns the resulting rows.
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
  /// The returned [JoinRateLimitHit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JoinRateLimitHit>> upsert(
    _is.DatabaseSession session,
    List<JoinRateLimitHit> rows, {
    required _is.ColumnSelections<JoinRateLimitHitTable> conflictColumns,
    _is.ColumnSelections<JoinRateLimitHitTable>? updateColumns,
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<JoinRateLimitHit>(
      rows,
      conflictColumns: conflictColumns(JoinRateLimitHit.t),
      updateColumns: updateColumns?.call(JoinRateLimitHit.t),
      updateWhere: updateWhere?.call(JoinRateLimitHit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [JoinRateLimitHit] and returns the resulting row.
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
  /// The returned [JoinRateLimitHit] will have its `id` field set.
  Future<JoinRateLimitHit?> upsertRow(
    _is.DatabaseSession session,
    JoinRateLimitHit row, {
    required _is.ColumnSelections<JoinRateLimitHitTable> conflictColumns,
    _is.ColumnSelections<JoinRateLimitHitTable>? updateColumns,
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<JoinRateLimitHit>(
      row,
      conflictColumns: conflictColumns(JoinRateLimitHit.t),
      updateColumns: updateColumns?.call(JoinRateLimitHit.t),
      updateWhere: updateWhere?.call(JoinRateLimitHit.t),
      transaction: transaction,
    );
  }

  /// Updates all [JoinRateLimitHit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JoinRateLimitHit>> update(
    _is.DatabaseSession session,
    List<JoinRateLimitHit> rows, {
    _is.ColumnSelections<JoinRateLimitHitTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<JoinRateLimitHit>(
      rows,
      columns: columns?.call(JoinRateLimitHit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [JoinRateLimitHit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JoinRateLimitHit> updateRow(
    _is.DatabaseSession session,
    JoinRateLimitHit row, {
    _is.ColumnSelections<JoinRateLimitHitTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<JoinRateLimitHit>(
      row,
      columns: columns?.call(JoinRateLimitHit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JoinRateLimitHit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JoinRateLimitHit?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<JoinRateLimitHitUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<JoinRateLimitHit>(
      id,
      columnValues: columnValues(JoinRateLimitHit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JoinRateLimitHit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JoinRateLimitHit>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<JoinRateLimitHitUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<JoinRateLimitHitTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JoinRateLimitHitTable>? orderBy,
    _is.OrderByListBuilder<JoinRateLimitHitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<JoinRateLimitHit>(
      columnValues: columnValues(JoinRateLimitHit.t.updateTable),
      where: where(JoinRateLimitHit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JoinRateLimitHit.t),
      orderByList: orderByList?.call(JoinRateLimitHit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [JoinRateLimitHit]s in the list and returns the deleted rows.
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
  Future<List<JoinRateLimitHit>> delete(
    _is.DatabaseSession session,
    List<JoinRateLimitHit> rows, {
    _is.OrderByBuilder<JoinRateLimitHitTable>? orderBy,
    _is.OrderByListBuilder<JoinRateLimitHitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<JoinRateLimitHit>(
      rows,
      orderBy: orderBy?.call(JoinRateLimitHit.t),
      orderByList: orderByList?.call(JoinRateLimitHit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [JoinRateLimitHit].
  Future<JoinRateLimitHit> deleteRow(
    _is.DatabaseSession session,
    JoinRateLimitHit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JoinRateLimitHit>(
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
  Future<List<JoinRateLimitHit>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JoinRateLimitHitTable> where,
    _is.OrderByBuilder<JoinRateLimitHitTable>? orderBy,
    _is.OrderByListBuilder<JoinRateLimitHitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<JoinRateLimitHit>(
      where: where(JoinRateLimitHit.t),
      orderBy: orderBy?.call(JoinRateLimitHit.t),
      orderByList: orderByList?.call(JoinRateLimitHit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JoinRateLimitHitTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<JoinRateLimitHit>(
      where: where?.call(JoinRateLimitHit.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [JoinRateLimitHit] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JoinRateLimitHitTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<JoinRateLimitHit>(
      where: where(JoinRateLimitHit.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
