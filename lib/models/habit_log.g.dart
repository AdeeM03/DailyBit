// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetHabitLogCollection on Isar {
  IsarCollection<int, HabitLog> get habitLogs => this.collection();
}

final HabitLogSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'HabitLog',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'habitId', type: IsarType.long),
      IsarPropertySchema(name: 'date', type: IsarType.string),
      IsarPropertySchema(name: 'isCompleted', type: IsarType.bool),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'habitId_date',
        properties: ["habitId", "date"],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'date',
        properties: ["date"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, HabitLog>(
    serialize: serializeHabitLog,
    deserialize: deserializeHabitLog,
    deserializeProperty: deserializeHabitLogProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeHabitLog(IsarWriter writer, HabitLog object) {
  IsarCore.writeLong(writer, 1, object.habitId);
  IsarCore.writeString(writer, 2, object.date);
  IsarCore.writeBool(writer, 3, value: object.isCompleted);
  return object.id;
}

@isarProtected
HabitLog deserializeHabitLog(IsarReader reader) {
  final int _id;
  _id = IsarCore.readId(reader);
  final int _habitId;
  {
    final value = IsarCore.readLong(reader, 1);
    if (value == -9223372036854775808) {
      _habitId = 0;
    } else {
      _habitId = value;
    }
  }
  final String _date;
  _date = IsarCore.readString(reader, 2) ?? '';
  final bool _isCompleted;
  _isCompleted = IsarCore.readBool(reader, 3);
  final object = HabitLog(
    id: _id,
    habitId: _habitId,
    date: _date,
    isCompleted: _isCompleted,
  );
  return object;
}

@isarProtected
dynamic deserializeHabitLogProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      {
        final value = IsarCore.readLong(reader, 1);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readBool(reader, 3);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _HabitLogUpdate {
  bool call({required int id, int? habitId, String? date, bool? isCompleted});
}

class _HabitLogUpdateImpl implements _HabitLogUpdate {
  const _HabitLogUpdateImpl(this.collection);

  final IsarCollection<int, HabitLog> collection;

  @override
  bool call({
    required int id,
    Object? habitId = ignore,
    Object? date = ignore,
    Object? isCompleted = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (habitId != ignore) 1: habitId as int?,
            if (date != ignore) 2: date as String?,
            if (isCompleted != ignore) 3: isCompleted as bool?,
          },
        ) >
        0;
  }
}

sealed class _HabitLogUpdateAll {
  int call({
    required List<int> id,
    int? habitId,
    String? date,
    bool? isCompleted,
  });
}

class _HabitLogUpdateAllImpl implements _HabitLogUpdateAll {
  const _HabitLogUpdateAllImpl(this.collection);

  final IsarCollection<int, HabitLog> collection;

  @override
  int call({
    required List<int> id,
    Object? habitId = ignore,
    Object? date = ignore,
    Object? isCompleted = ignore,
  }) {
    return collection.updateProperties(id, {
      if (habitId != ignore) 1: habitId as int?,
      if (date != ignore) 2: date as String?,
      if (isCompleted != ignore) 3: isCompleted as bool?,
    });
  }
}

extension HabitLogUpdate on IsarCollection<int, HabitLog> {
  _HabitLogUpdate get update => _HabitLogUpdateImpl(this);

  _HabitLogUpdateAll get updateAll => _HabitLogUpdateAllImpl(this);
}

sealed class _HabitLogQueryUpdate {
  int call({int? habitId, String? date, bool? isCompleted});
}

class _HabitLogQueryUpdateImpl implements _HabitLogQueryUpdate {
  const _HabitLogQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<HabitLog> query;
  final int? limit;

  @override
  int call({
    Object? habitId = ignore,
    Object? date = ignore,
    Object? isCompleted = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (habitId != ignore) 1: habitId as int?,
      if (date != ignore) 2: date as String?,
      if (isCompleted != ignore) 3: isCompleted as bool?,
    });
  }
}

extension HabitLogQueryUpdate on IsarQuery<HabitLog> {
  _HabitLogQueryUpdate get updateFirst =>
      _HabitLogQueryUpdateImpl(this, limit: 1);

  _HabitLogQueryUpdate get updateAll => _HabitLogQueryUpdateImpl(this);
}

class _HabitLogQueryBuilderUpdateImpl implements _HabitLogQueryUpdate {
  const _HabitLogQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<HabitLog, HabitLog, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? habitId = ignore,
    Object? date = ignore,
    Object? isCompleted = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (habitId != ignore) 1: habitId as int?,
        if (date != ignore) 2: date as String?,
        if (isCompleted != ignore) 3: isCompleted as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension HabitLogQueryBuilderUpdate
    on QueryBuilder<HabitLog, HabitLog, QOperations> {
  _HabitLogQueryUpdate get updateFirst =>
      _HabitLogQueryBuilderUpdateImpl(this, limit: 1);

  _HabitLogQueryUpdate get updateAll => _HabitLogQueryBuilderUpdateImpl(this);
}

extension HabitLogQueryFilter
    on QueryBuilder<HabitLog, HabitLog, QFilterCondition> {
  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition>
  habitIdGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 1, value: value));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition>
  habitIdLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 1, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition>
  dateGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> isCompletedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }
}

extension HabitLogQueryObject
    on QueryBuilder<HabitLog, HabitLog, QFilterCondition> {}

extension HabitLogQuerySortBy on QueryBuilder<HabitLog, HabitLog, QSortBy> {
  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByDateDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }
}

extension HabitLogQuerySortThenBy
    on QueryBuilder<HabitLog, HabitLog, QSortThenBy> {
  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByDateDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }
}

extension HabitLogQueryWhereDistinct
    on QueryBuilder<HabitLog, HabitLog, QDistinct> {
  QueryBuilder<HabitLog, HabitLog, QAfterDistinct> distinctByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterDistinct> distinctByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterDistinct> distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }
}

extension HabitLogQueryProperty1
    on QueryBuilder<HabitLog, HabitLog, QProperty> {
  QueryBuilder<HabitLog, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<HabitLog, int, QAfterProperty> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<HabitLog, String, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<HabitLog, bool, QAfterProperty> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension HabitLogQueryProperty2<R>
    on QueryBuilder<HabitLog, R, QAfterProperty> {
  QueryBuilder<HabitLog, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<HabitLog, (R, int), QAfterProperty> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<HabitLog, (R, String), QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<HabitLog, (R, bool), QAfterProperty> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension HabitLogQueryProperty3<R1, R2>
    on QueryBuilder<HabitLog, (R1, R2), QAfterProperty> {
  QueryBuilder<HabitLog, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<HabitLog, (R1, R2, int), QOperations> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<HabitLog, (R1, R2, String), QOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<HabitLog, (R1, R2, bool), QOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
