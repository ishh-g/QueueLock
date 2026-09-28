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

/// One observed service duration, used by the wait-time estimator.
abstract class ServiceSample
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ServiceSample._({
    this.id,
    required this.queueId,
    this.counterId,
    required this.hourOfDay,
    required this.durationSec,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ServiceSample({
    int? id,
    required int queueId,
    int? counterId,
    required int hourOfDay,
    required double durationSec,
    DateTime? createdAt,
  }) = _ServiceSampleImpl;

  factory ServiceSample.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceSample(
      id: jsonSerialization['id'] as int?,
      queueId: jsonSerialization['queueId'] as int,
      counterId: jsonSerialization['counterId'] as int?,
      hourOfDay: jsonSerialization['hourOfDay'] as int,
      durationSec: (jsonSerialization['durationSec'] as num).toDouble(),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ServiceSampleTable();

  static const db = ServiceSampleRepository._();

  @override
  int? id;

  int queueId;

  int? counterId;

  int hourOfDay;

  double durationSec;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ServiceSample]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServiceSample copyWith({
    int? id,
    int? queueId,
    int? counterId,
    int? hourOfDay,
    double? durationSec,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceSample',
      if (id != null) 'id': id,
      'queueId': queueId,
      if (counterId != null) 'counterId': counterId,
      'hourOfDay': hourOfDay,
      'durationSec': durationSec,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServiceSample',
      if (id != null) 'id': id,
      'queueId': queueId,
      if (counterId != null) 'counterId': counterId,
      'hourOfDay': hourOfDay,
      'durationSec': durationSec,
      'createdAt': createdAt.toJson(),
    };
  }

  static ServiceSampleInclude include() {
    return ServiceSampleInclude._();
  }

  static ServiceSampleIncludeList includeList({
    _is.WhereExpressionBuilder<ServiceSampleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceSampleTable>? orderBy,
    _is.OrderByListBuilder<ServiceSampleTable>? orderByList,
    ServiceSampleInclude? include,
  }) {
    return ServiceSampleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServiceSample.t),
      orderByList: orderByList?.call(ServiceSample.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceSampleImpl extends ServiceSample {
  _ServiceSampleImpl({
    int? id,
    required int queueId,
    int? counterId,
    required int hourOfDay,
    required double durationSec,
    DateTime? createdAt,
  }) : super._(
         id: id,
         queueId: queueId,
         counterId: counterId,
         hourOfDay: hourOfDay,
         durationSec: durationSec,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ServiceSample]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServiceSample copyWith({
    Object? id = _Undefined,
    int? queueId,
    Object? counterId = _Undefined,
    int? hourOfDay,
    double? durationSec,
    DateTime? createdAt,
  }) {
    return ServiceSample(
      id: id is int? ? id : this.id,
      queueId: queueId ?? this.queueId,
      counterId: counterId is int? ? counterId : this.counterId,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      durationSec: durationSec ?? this.durationSec,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ServiceSampleUpdateTable extends _is.UpdateTable<ServiceSampleTable> {
  ServiceSampleUpdateTable(super.table);

  _is.ColumnValue<int, int> queueId(int value) => _is.ColumnValue(
    table.queueId,
    value,
  );

  _is.ColumnValue<int, int> counterId(int? value) => _is.ColumnValue(
    table.counterId,
    value,
  );

  _is.ColumnValue<int, int> hourOfDay(int value) => _is.ColumnValue(
    table.hourOfDay,
    value,
  );

  _is.ColumnValue<double, double> durationSec(double value) => _is.ColumnValue(
    table.durationSec,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ServiceSampleTable extends _is.Table<int?> {
  ServiceSampleTable({super.tableRelation})
    : super(tableName: 'service_sample') {
    updateTable = ServiceSampleUpdateTable(this);
    queueId = _is.ColumnInt(
      'queueId',
      this,
    );
    counterId = _is.ColumnInt(
      'counterId',
      this,
    );
    hourOfDay = _is.ColumnInt(
      'hourOfDay',
      this,
    );
    durationSec = _is.ColumnDouble(
      'durationSec',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ServiceSampleUpdateTable updateTable;

  late final _is.ColumnInt queueId;

  late final _is.ColumnInt counterId;

  late final _is.ColumnInt hourOfDay;

  late final _is.ColumnDouble durationSec;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    queueId,
    counterId,
    hourOfDay,
    durationSec,
    createdAt,
  ];
}

class ServiceSampleInclude extends _is.IncludeObject {
  ServiceSampleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ServiceSample.t;
}

class ServiceSampleIncludeList extends _is.IncludeList {
  ServiceSampleIncludeList._({
    _is.WhereExpressionBuilder<ServiceSampleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServiceSample.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ServiceSample.t;
}

class ServiceSampleRepository {
  const ServiceSampleRepository._();

  /// Returns a list of [ServiceSample]s matching the given query parameters.
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
  Future<List<ServiceSample>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceSampleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceSampleTable>? orderBy,
    _is.OrderByListBuilder<ServiceSampleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ServiceSample>(
      where: where?.call(ServiceSample.t),
      orderBy: orderBy?.call(ServiceSample.t),
      orderByList: orderByList?.call(ServiceSample.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ServiceSample] matching the given query parameters.
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
  Future<ServiceSample?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceSampleTable>? where,
    int? offset,
    _is.OrderByBuilder<ServiceSampleTable>? orderBy,
    _is.OrderByListBuilder<ServiceSampleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ServiceSample>(
      where: where?.call(ServiceSample.t),
      orderBy: orderBy?.call(ServiceSample.t),
      orderByList: orderByList?.call(ServiceSample.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ServiceSample] by its [id] or null if no such row exists.
  Future<ServiceSample?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ServiceSample>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ServiceSample]s in the list and returns the inserted rows.
  ///
  /// The returned [ServiceSample]s will have their `id` fields set.
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
  Future<List<ServiceSample>> insert(
    _is.DatabaseSession session,
    List<ServiceSample> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ServiceSample>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ServiceSample] and returns the inserted row.
  ///
  /// The returned [ServiceSample] will have its `id` field set.
  Future<ServiceSample> insertRow(
    _is.DatabaseSession session,
    ServiceSample row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServiceSample>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ServiceSample]s in the list and returns the resulting rows.
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
  /// The returned [ServiceSample]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServiceSample>> upsert(
    _is.DatabaseSession session,
    List<ServiceSample> rows, {
    required _is.ColumnSelections<ServiceSampleTable> conflictColumns,
    _is.ColumnSelections<ServiceSampleTable>? updateColumns,
    _is.WhereExpressionBuilder<ServiceSampleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ServiceSample>(
      rows,
      conflictColumns: conflictColumns(ServiceSample.t),
      updateColumns: updateColumns?.call(ServiceSample.t),
      updateWhere: updateWhere?.call(ServiceSample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ServiceSample] and returns the resulting row.
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
  /// The returned [ServiceSample] will have its `id` field set.
  Future<ServiceSample?> upsertRow(
    _is.DatabaseSession session,
    ServiceSample row, {
    required _is.ColumnSelections<ServiceSampleTable> conflictColumns,
    _is.ColumnSelections<ServiceSampleTable>? updateColumns,
    _is.WhereExpressionBuilder<ServiceSampleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ServiceSample>(
      row,
      conflictColumns: conflictColumns(ServiceSample.t),
      updateColumns: updateColumns?.call(ServiceSample.t),
      updateWhere: updateWhere?.call(ServiceSample.t),
      transaction: transaction,
    );
  }

  /// Updates all [ServiceSample]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServiceSample>> update(
    _is.DatabaseSession session,
    List<ServiceSample> rows, {
    _is.ColumnSelections<ServiceSampleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ServiceSample>(
      rows,
      columns: columns?.call(ServiceSample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ServiceSample]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServiceSample> updateRow(
    _is.DatabaseSession session,
    ServiceSample row, {
    _is.ColumnSelections<ServiceSampleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ServiceSample>(
      row,
      columns: columns?.call(ServiceSample.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServiceSample] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ServiceSample?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ServiceSampleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ServiceSample>(
      id,
      columnValues: columnValues(ServiceSample.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ServiceSample]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServiceSample>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ServiceSampleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ServiceSampleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceSampleTable>? orderBy,
    _is.OrderByListBuilder<ServiceSampleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ServiceSample>(
      columnValues: columnValues(ServiceSample.t.updateTable),
      where: where(ServiceSample.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServiceSample.t),
      orderByList: orderByList?.call(ServiceSample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ServiceSample]s in the list and returns the deleted rows.
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
  Future<List<ServiceSample>> delete(
    _is.DatabaseSession session,
    List<ServiceSample> rows, {
    _is.OrderByBuilder<ServiceSampleTable>? orderBy,
    _is.OrderByListBuilder<ServiceSampleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ServiceSample>(
      rows,
      orderBy: orderBy?.call(ServiceSample.t),
      orderByList: orderByList?.call(ServiceSample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ServiceSample].
  Future<ServiceSample> deleteRow(
    _is.DatabaseSession session,
    ServiceSample row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServiceSample>(
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
  Future<List<ServiceSample>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServiceSampleTable> where,
    _is.OrderByBuilder<ServiceSampleTable>? orderBy,
    _is.OrderByListBuilder<ServiceSampleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ServiceSample>(
      where: where(ServiceSample.t),
      orderBy: orderBy?.call(ServiceSample.t),
      orderByList: orderByList?.call(ServiceSample.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceSampleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ServiceSample>(
      where: where?.call(ServiceSample.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ServiceSample] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServiceSampleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ServiceSample>(
      where: where(ServiceSample.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
