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

/// A service counter belonging to a queue.
abstract class Counter
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Counter._({
    this.id,
    required this.queueId,
    required this.name,
    bool? active,
  }) : active = active ?? true;

  factory Counter({
    int? id,
    required int queueId,
    required String name,
    bool? active,
  }) = _CounterImpl;

  factory Counter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Counter(
      id: jsonSerialization['id'] as int?,
      queueId: jsonSerialization['queueId'] as int,
      name: jsonSerialization['name'] as String,
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  static final t = CounterTable();

  static const db = CounterRepository._();

  @override
  int? id;

  int queueId;

  String name;

  bool active;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Counter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Counter copyWith({
    int? id,
    int? queueId,
    String? name,
    bool? active,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Counter',
      if (id != null) 'id': id,
      'queueId': queueId,
      'name': name,
      'active': active,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Counter',
      if (id != null) 'id': id,
      'queueId': queueId,
      'name': name,
      'active': active,
    };
  }

  static CounterInclude include() {
    return CounterInclude._();
  }

  static CounterIncludeList includeList({
    _is.WhereExpressionBuilder<CounterTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CounterTable>? orderBy,
    _is.OrderByListBuilder<CounterTable>? orderByList,
    CounterInclude? include,
  }) {
    return CounterIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CounterImpl extends Counter {
  _CounterImpl({
    int? id,
    required int queueId,
    required String name,
    bool? active,
  }) : super._(
         id: id,
         queueId: queueId,
         name: name,
         active: active,
       );

  /// Returns a shallow copy of this [Counter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Counter copyWith({
    Object? id = _Undefined,
    int? queueId,
    String? name,
    bool? active,
  }) {
    return Counter(
      id: id is int? ? id : this.id,
      queueId: queueId ?? this.queueId,
      name: name ?? this.name,
      active: active ?? this.active,
    );
  }
}

class CounterUpdateTable extends _is.UpdateTable<CounterTable> {
  CounterUpdateTable(super.table);

  _is.ColumnValue<int, int> queueId(int value) => _is.ColumnValue(
    table.queueId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );
}

class CounterTable extends _is.Table<int?> {
  CounterTable({super.tableRelation}) : super(tableName: 'counter') {
    updateTable = CounterUpdateTable(this);
    queueId = _is.ColumnInt(
      'queueId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
  }

  late final CounterUpdateTable updateTable;

  late final _is.ColumnInt queueId;

  late final _is.ColumnString name;

  late final _is.ColumnBool active;

  @override
  List<_is.Column> get columns => [
    id,
    queueId,
    name,
    active,
  ];
}

class CounterInclude extends _is.IncludeObject {
  CounterInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Counter.t;
}

class CounterIncludeList extends _is.IncludeList {
  CounterIncludeList._({
    _is.WhereExpressionBuilder<CounterTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Counter.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Counter.t;
}

class CounterRepository {
  const CounterRepository._();

  /// Returns a list of [Counter]s matching the given query parameters.
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
  Future<List<Counter>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CounterTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CounterTable>? orderBy,
    _is.OrderByListBuilder<CounterTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Counter>(
      where: where?.call(Counter.t),
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Counter] matching the given query parameters.
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
  Future<Counter?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CounterTable>? where,
    int? offset,
    _is.OrderByBuilder<CounterTable>? orderBy,
    _is.OrderByListBuilder<CounterTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Counter>(
      where: where?.call(Counter.t),
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Counter] by its [id] or null if no such row exists.
  Future<Counter?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Counter>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Counter]s in the list and returns the inserted rows.
  ///
  /// The returned [Counter]s will have their `id` fields set.
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
  Future<List<Counter>> insert(
    _is.DatabaseSession session,
    List<Counter> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Counter>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Counter] and returns the inserted row.
  ///
  /// The returned [Counter] will have its `id` field set.
  Future<Counter> insertRow(
    _is.DatabaseSession session,
    Counter row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Counter>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Counter]s in the list and returns the resulting rows.
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
  /// The returned [Counter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Counter>> upsert(
    _is.DatabaseSession session,
    List<Counter> rows, {
    required _is.ColumnSelections<CounterTable> conflictColumns,
    _is.ColumnSelections<CounterTable>? updateColumns,
    _is.WhereExpressionBuilder<CounterTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Counter>(
      rows,
      conflictColumns: conflictColumns(Counter.t),
      updateColumns: updateColumns?.call(Counter.t),
      updateWhere: updateWhere?.call(Counter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Counter] and returns the resulting row.
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
  /// The returned [Counter] will have its `id` field set.
  Future<Counter?> upsertRow(
    _is.DatabaseSession session,
    Counter row, {
    required _is.ColumnSelections<CounterTable> conflictColumns,
    _is.ColumnSelections<CounterTable>? updateColumns,
    _is.WhereExpressionBuilder<CounterTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Counter>(
      row,
      conflictColumns: conflictColumns(Counter.t),
      updateColumns: updateColumns?.call(Counter.t),
      updateWhere: updateWhere?.call(Counter.t),
      transaction: transaction,
    );
  }

  /// Updates all [Counter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Counter>> update(
    _is.DatabaseSession session,
    List<Counter> rows, {
    _is.ColumnSelections<CounterTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Counter>(
      rows,
      columns: columns?.call(Counter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Counter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Counter> updateRow(
    _is.DatabaseSession session,
    Counter row, {
    _is.ColumnSelections<CounterTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Counter>(
      row,
      columns: columns?.call(Counter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Counter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Counter?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CounterUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Counter>(
      id,
      columnValues: columnValues(Counter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Counter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Counter>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CounterUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CounterTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CounterTable>? orderBy,
    _is.OrderByListBuilder<CounterTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Counter>(
      columnValues: columnValues(Counter.t.updateTable),
      where: where(Counter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Counter]s in the list and returns the deleted rows.
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
  Future<List<Counter>> delete(
    _is.DatabaseSession session,
    List<Counter> rows, {
    _is.OrderByBuilder<CounterTable>? orderBy,
    _is.OrderByListBuilder<CounterTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Counter>(
      rows,
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Counter].
  Future<Counter> deleteRow(
    _is.DatabaseSession session,
    Counter row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Counter>(
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
  Future<List<Counter>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CounterTable> where,
    _is.OrderByBuilder<CounterTable>? orderBy,
    _is.OrderByListBuilder<CounterTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Counter>(
      where: where(Counter.t),
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CounterTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Counter>(
      where: where?.call(Counter.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Counter] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CounterTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Counter>(
      where: where(Counter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
