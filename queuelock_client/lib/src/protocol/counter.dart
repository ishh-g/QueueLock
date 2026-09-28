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

/// A service counter belonging to a queue.
abstract class Counter
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int queueId;

  String name;

  bool active;

  /// Returns a shallow copy of this [Counter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
