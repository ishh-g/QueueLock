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
import 'queue_status.dart' as _i209jpy3;

/// A virtual queue owned by one staff user.
abstract class Queue implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Queue._({
    this.id,
    required this.slug,
    required this.name,
    required this.status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    required this.ownerId,
  }) : callTimeoutSec = callTimeoutSec ?? 180,
       lastNumber = lastNumber ?? 0,
       headSeq = headSeq ?? 0,
       headHash =
           headHash ??
           '0000000000000000000000000000000000000000000000000000000000000000',
       avgServiceSec = avgServiceSec ?? 300.0,
       sampleCount = sampleCount ?? 0;

  factory Queue({
    int? id,
    required String slug,
    required String name,
    required _i209jpy3.QueueStatus status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    required _is.UuidValue ownerId,
  }) = _QueueImpl;

  factory Queue.fromJson(Map<String, dynamic> jsonSerialization) {
    return Queue(
      id: jsonSerialization['id'] as int?,
      slug: jsonSerialization['slug'] as String,
      name: jsonSerialization['name'] as String,
      status: _i209jpy3.QueueStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      callTimeoutSec: jsonSerialization['callTimeoutSec'] as int?,
      lastNumber: jsonSerialization['lastNumber'] as int?,
      headSeq: jsonSerialization['headSeq'] as int?,
      headHash: jsonSerialization['headHash'] as String?,
      avgServiceSec: (jsonSerialization['avgServiceSec'] as num?)?.toDouble(),
      sampleCount: jsonSerialization['sampleCount'] as int?,
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
    );
  }

  static final t = QueueTable();

  static const db = QueueRepository._();

  @override
  int? id;

  String slug;

  String name;

  _i209jpy3.QueueStatus status;

  int callTimeoutSec;

  int lastNumber;

  int headSeq;

  String headHash;

  double avgServiceSec;

  int sampleCount;

  _is.UuidValue ownerId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Queue]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Queue copyWith({
    int? id,
    String? slug,
    String? name,
    _i209jpy3.QueueStatus? status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    _is.UuidValue? ownerId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Queue',
      if (id != null) 'id': id,
      'slug': slug,
      'name': name,
      'status': status.toJson(),
      'callTimeoutSec': callTimeoutSec,
      'lastNumber': lastNumber,
      'headSeq': headSeq,
      'headHash': headHash,
      'avgServiceSec': avgServiceSec,
      'sampleCount': sampleCount,
      'ownerId': ownerId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Queue',
      if (id != null) 'id': id,
      'slug': slug,
      'name': name,
      'status': status.toJson(),
      'callTimeoutSec': callTimeoutSec,
      'lastNumber': lastNumber,
      'headSeq': headSeq,
      'headHash': headHash,
      'avgServiceSec': avgServiceSec,
      'sampleCount': sampleCount,
      'ownerId': ownerId.toJson(),
    };
  }

  static QueueInclude include() {
    return QueueInclude._();
  }

  static QueueIncludeList includeList({
    _is.WhereExpressionBuilder<QueueTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueueTable>? orderBy,
    _is.OrderByListBuilder<QueueTable>? orderByList,
    QueueInclude? include,
  }) {
    return QueueIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Queue.t),
      orderByList: orderByList?.call(Queue.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueueImpl extends Queue {
  _QueueImpl({
    int? id,
    required String slug,
    required String name,
    required _i209jpy3.QueueStatus status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    required _is.UuidValue ownerId,
  }) : super._(
         id: id,
         slug: slug,
         name: name,
         status: status,
         callTimeoutSec: callTimeoutSec,
         lastNumber: lastNumber,
         headSeq: headSeq,
         headHash: headHash,
         avgServiceSec: avgServiceSec,
         sampleCount: sampleCount,
         ownerId: ownerId,
       );

  /// Returns a shallow copy of this [Queue]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Queue copyWith({
    Object? id = _Undefined,
    String? slug,
    String? name,
    _i209jpy3.QueueStatus? status,
    int? callTimeoutSec,
    int? lastNumber,
    int? headSeq,
    String? headHash,
    double? avgServiceSec,
    int? sampleCount,
    _is.UuidValue? ownerId,
  }) {
    return Queue(
      id: id is int? ? id : this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      status: status ?? this.status,
      callTimeoutSec: callTimeoutSec ?? this.callTimeoutSec,
      lastNumber: lastNumber ?? this.lastNumber,
      headSeq: headSeq ?? this.headSeq,
      headHash: headHash ?? this.headHash,
      avgServiceSec: avgServiceSec ?? this.avgServiceSec,
      sampleCount: sampleCount ?? this.sampleCount,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}

class QueueUpdateTable extends _is.UpdateTable<QueueTable> {
  QueueUpdateTable(super.table);

  _is.ColumnValue<String, String> slug(String value) => _is.ColumnValue(
    table.slug,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_i209jpy3.QueueStatus, _i209jpy3.QueueStatus> status(
    _i209jpy3.QueueStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> callTimeoutSec(int value) => _is.ColumnValue(
    table.callTimeoutSec,
    value,
  );

  _is.ColumnValue<int, int> lastNumber(int value) => _is.ColumnValue(
    table.lastNumber,
    value,
  );

  _is.ColumnValue<int, int> headSeq(int value) => _is.ColumnValue(
    table.headSeq,
    value,
  );

  _is.ColumnValue<String, String> headHash(String value) => _is.ColumnValue(
    table.headHash,
    value,
  );

  _is.ColumnValue<double, double> avgServiceSec(double value) =>
      _is.ColumnValue(
        table.avgServiceSec,
        value,
      );

  _is.ColumnValue<int, int> sampleCount(int value) => _is.ColumnValue(
    table.sampleCount,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );
}

class QueueTable extends _is.Table<int?> {
  QueueTable({super.tableRelation}) : super(tableName: 'queue') {
    updateTable = QueueUpdateTable(this);
    slug = _is.ColumnString(
      'slug',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    callTimeoutSec = _is.ColumnInt(
      'callTimeoutSec',
      this,
      hasDefault: true,
    );
    lastNumber = _is.ColumnInt(
      'lastNumber',
      this,
      hasDefault: true,
    );
    headSeq = _is.ColumnInt(
      'headSeq',
      this,
      hasDefault: true,
    );
    headHash = _is.ColumnString(
      'headHash',
      this,
      hasDefault: true,
    );
    avgServiceSec = _is.ColumnDouble(
      'avgServiceSec',
      this,
      hasDefault: true,
    );
    sampleCount = _is.ColumnInt(
      'sampleCount',
      this,
      hasDefault: true,
    );
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
  }

  late final QueueUpdateTable updateTable;

  late final _is.ColumnString slug;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_i209jpy3.QueueStatus> status;

  late final _is.ColumnInt callTimeoutSec;

  late final _is.ColumnInt lastNumber;

  late final _is.ColumnInt headSeq;

  late final _is.ColumnString headHash;

  late final _is.ColumnDouble avgServiceSec;

  late final _is.ColumnInt sampleCount;

  late final _is.ColumnUuid ownerId;

  @override
  List<_is.Column> get columns => [
    id,
    slug,
    name,
    status,
    callTimeoutSec,
    lastNumber,
    headSeq,
    headHash,
    avgServiceSec,
    sampleCount,
    ownerId,
  ];
}

class QueueInclude extends _is.IncludeObject {
  QueueInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Queue.t;
}

class QueueIncludeList extends _is.IncludeList {
  QueueIncludeList._({
    _is.WhereExpressionBuilder<QueueTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Queue.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Queue.t;
}

class QueueRepository {
  const QueueRepository._();

  /// Returns a list of [Queue]s matching the given query parameters.
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
  Future<List<Queue>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueueTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueueTable>? orderBy,
    _is.OrderByListBuilder<QueueTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Queue>(
      where: where?.call(Queue.t),
      orderBy: orderBy?.call(Queue.t),
      orderByList: orderByList?.call(Queue.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Queue] matching the given query parameters.
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
  Future<Queue?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueueTable>? where,
    int? offset,
    _is.OrderByBuilder<QueueTable>? orderBy,
    _is.OrderByListBuilder<QueueTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Queue>(
      where: where?.call(Queue.t),
      orderBy: orderBy?.call(Queue.t),
      orderByList: orderByList?.call(Queue.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Queue] by its [id] or null if no such row exists.
  Future<Queue?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Queue>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Queue]s in the list and returns the inserted rows.
  ///
  /// The returned [Queue]s will have their `id` fields set.
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
  Future<List<Queue>> insert(
    _is.DatabaseSession session,
    List<Queue> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Queue>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Queue] and returns the inserted row.
  ///
  /// The returned [Queue] will have its `id` field set.
  Future<Queue> insertRow(
    _is.DatabaseSession session,
    Queue row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Queue>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Queue]s in the list and returns the resulting rows.
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
  /// The returned [Queue]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Queue>> upsert(
    _is.DatabaseSession session,
    List<Queue> rows, {
    required _is.ColumnSelections<QueueTable> conflictColumns,
    _is.ColumnSelections<QueueTable>? updateColumns,
    _is.WhereExpressionBuilder<QueueTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Queue>(
      rows,
      conflictColumns: conflictColumns(Queue.t),
      updateColumns: updateColumns?.call(Queue.t),
      updateWhere: updateWhere?.call(Queue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Queue] and returns the resulting row.
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
  /// The returned [Queue] will have its `id` field set.
  Future<Queue?> upsertRow(
    _is.DatabaseSession session,
    Queue row, {
    required _is.ColumnSelections<QueueTable> conflictColumns,
    _is.ColumnSelections<QueueTable>? updateColumns,
    _is.WhereExpressionBuilder<QueueTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Queue>(
      row,
      conflictColumns: conflictColumns(Queue.t),
      updateColumns: updateColumns?.call(Queue.t),
      updateWhere: updateWhere?.call(Queue.t),
      transaction: transaction,
    );
  }

  /// Updates all [Queue]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Queue>> update(
    _is.DatabaseSession session,
    List<Queue> rows, {
    _is.ColumnSelections<QueueTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Queue>(
      rows,
      columns: columns?.call(Queue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Queue]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Queue> updateRow(
    _is.DatabaseSession session,
    Queue row, {
    _is.ColumnSelections<QueueTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Queue>(
      row,
      columns: columns?.call(Queue.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Queue] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Queue?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<QueueUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Queue>(
      id,
      columnValues: columnValues(Queue.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Queue]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Queue>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<QueueUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<QueueTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueueTable>? orderBy,
    _is.OrderByListBuilder<QueueTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Queue>(
      columnValues: columnValues(Queue.t.updateTable),
      where: where(Queue.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Queue.t),
      orderByList: orderByList?.call(Queue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Queue]s in the list and returns the deleted rows.
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
  Future<List<Queue>> delete(
    _is.DatabaseSession session,
    List<Queue> rows, {
    _is.OrderByBuilder<QueueTable>? orderBy,
    _is.OrderByListBuilder<QueueTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Queue>(
      rows,
      orderBy: orderBy?.call(Queue.t),
      orderByList: orderByList?.call(Queue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Queue].
  Future<Queue> deleteRow(
    _is.DatabaseSession session,
    Queue row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Queue>(
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
  Future<List<Queue>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QueueTable> where,
    _is.OrderByBuilder<QueueTable>? orderBy,
    _is.OrderByListBuilder<QueueTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Queue>(
      where: where(Queue.t),
      orderBy: orderBy?.call(Queue.t),
      orderByList: orderByList?.call(Queue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueueTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Queue>(
      where: where?.call(Queue.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Queue] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QueueTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Queue>(
      where: where(Queue.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
