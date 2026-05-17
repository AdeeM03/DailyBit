// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDiaryEntryCollection on Isar {
  IsarCollection<int, DiaryEntry> get diaryEntrys => this.collection();
}

final DiaryEntrySchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'DiaryEntry',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'date', type: IsarType.string),
      IsarPropertySchema(name: 'dateLabel', type: IsarType.string),
      IsarPropertySchema(name: 'emoji', type: IsarType.string),
      IsarPropertySchema(name: 'emojiColorHex', type: IsarType.long),
      IsarPropertySchema(name: 'moodLevel', type: IsarType.long),
      IsarPropertySchema(name: 'title', type: IsarType.string),
      IsarPropertySchema(name: 'body', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'date',
        properties: ["date"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, DiaryEntry>(
    serialize: serializeDiaryEntry,
    deserialize: deserializeDiaryEntry,
    deserializeProperty: deserializeDiaryEntryProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeDiaryEntry(IsarWriter writer, DiaryEntry object) {
  IsarCore.writeString(writer, 1, object.date);
  IsarCore.writeString(writer, 2, object.dateLabel);
  IsarCore.writeString(writer, 3, object.emoji);
  IsarCore.writeLong(writer, 4, object.emojiColorHex);
  IsarCore.writeLong(writer, 5, object.moodLevel);
  IsarCore.writeString(writer, 6, object.title);
  IsarCore.writeString(writer, 7, object.body);
  return object.id;
}

@isarProtected
DiaryEntry deserializeDiaryEntry(IsarReader reader) {
  final int _id;
  _id = IsarCore.readId(reader);
  final String _date;
  _date = IsarCore.readString(reader, 1) ?? '';
  final String _dateLabel;
  _dateLabel = IsarCore.readString(reader, 2) ?? '';
  final String _emoji;
  _emoji = IsarCore.readString(reader, 3) ?? '';
  final int _emojiColorHex;
  {
    final value = IsarCore.readLong(reader, 4);
    if (value == -9223372036854775808) {
      _emojiColorHex = 0;
    } else {
      _emojiColorHex = value;
    }
  }
  final int _moodLevel;
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      _moodLevel = 3;
    } else {
      _moodLevel = value;
    }
  }
  final String _title;
  _title = IsarCore.readString(reader, 6) ?? '';
  final String _body;
  _body = IsarCore.readString(reader, 7) ?? '';
  final object = DiaryEntry(
    id: _id,
    date: _date,
    dateLabel: _dateLabel,
    emoji: _emoji,
    emojiColorHex: _emojiColorHex,
    moodLevel: _moodLevel,
    title: _title,
    body: _body,
  );
  return object;
}

@isarProtected
dynamic deserializeDiaryEntryProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return 3;
        } else {
          return value;
        }
      }
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readString(reader, 7) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DiaryEntryUpdate {
  bool call({
    required int id,
    String? date,
    String? dateLabel,
    String? emoji,
    int? emojiColorHex,
    int? moodLevel,
    String? title,
    String? body,
  });
}

class _DiaryEntryUpdateImpl implements _DiaryEntryUpdate {
  const _DiaryEntryUpdateImpl(this.collection);

  final IsarCollection<int, DiaryEntry> collection;

  @override
  bool call({
    required int id,
    Object? date = ignore,
    Object? dateLabel = ignore,
    Object? emoji = ignore,
    Object? emojiColorHex = ignore,
    Object? moodLevel = ignore,
    Object? title = ignore,
    Object? body = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (date != ignore) 1: date as String?,
            if (dateLabel != ignore) 2: dateLabel as String?,
            if (emoji != ignore) 3: emoji as String?,
            if (emojiColorHex != ignore) 4: emojiColorHex as int?,
            if (moodLevel != ignore) 5: moodLevel as int?,
            if (title != ignore) 6: title as String?,
            if (body != ignore) 7: body as String?,
          },
        ) >
        0;
  }
}

sealed class _DiaryEntryUpdateAll {
  int call({
    required List<int> id,
    String? date,
    String? dateLabel,
    String? emoji,
    int? emojiColorHex,
    int? moodLevel,
    String? title,
    String? body,
  });
}

class _DiaryEntryUpdateAllImpl implements _DiaryEntryUpdateAll {
  const _DiaryEntryUpdateAllImpl(this.collection);

  final IsarCollection<int, DiaryEntry> collection;

  @override
  int call({
    required List<int> id,
    Object? date = ignore,
    Object? dateLabel = ignore,
    Object? emoji = ignore,
    Object? emojiColorHex = ignore,
    Object? moodLevel = ignore,
    Object? title = ignore,
    Object? body = ignore,
  }) {
    return collection.updateProperties(id, {
      if (date != ignore) 1: date as String?,
      if (dateLabel != ignore) 2: dateLabel as String?,
      if (emoji != ignore) 3: emoji as String?,
      if (emojiColorHex != ignore) 4: emojiColorHex as int?,
      if (moodLevel != ignore) 5: moodLevel as int?,
      if (title != ignore) 6: title as String?,
      if (body != ignore) 7: body as String?,
    });
  }
}

extension DiaryEntryUpdate on IsarCollection<int, DiaryEntry> {
  _DiaryEntryUpdate get update => _DiaryEntryUpdateImpl(this);

  _DiaryEntryUpdateAll get updateAll => _DiaryEntryUpdateAllImpl(this);
}

sealed class _DiaryEntryQueryUpdate {
  int call({
    String? date,
    String? dateLabel,
    String? emoji,
    int? emojiColorHex,
    int? moodLevel,
    String? title,
    String? body,
  });
}

class _DiaryEntryQueryUpdateImpl implements _DiaryEntryQueryUpdate {
  const _DiaryEntryQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<DiaryEntry> query;
  final int? limit;

  @override
  int call({
    Object? date = ignore,
    Object? dateLabel = ignore,
    Object? emoji = ignore,
    Object? emojiColorHex = ignore,
    Object? moodLevel = ignore,
    Object? title = ignore,
    Object? body = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (date != ignore) 1: date as String?,
      if (dateLabel != ignore) 2: dateLabel as String?,
      if (emoji != ignore) 3: emoji as String?,
      if (emojiColorHex != ignore) 4: emojiColorHex as int?,
      if (moodLevel != ignore) 5: moodLevel as int?,
      if (title != ignore) 6: title as String?,
      if (body != ignore) 7: body as String?,
    });
  }
}

extension DiaryEntryQueryUpdate on IsarQuery<DiaryEntry> {
  _DiaryEntryQueryUpdate get updateFirst =>
      _DiaryEntryQueryUpdateImpl(this, limit: 1);

  _DiaryEntryQueryUpdate get updateAll => _DiaryEntryQueryUpdateImpl(this);
}

class _DiaryEntryQueryBuilderUpdateImpl implements _DiaryEntryQueryUpdate {
  const _DiaryEntryQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<DiaryEntry, DiaryEntry, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? date = ignore,
    Object? dateLabel = ignore,
    Object? emoji = ignore,
    Object? emojiColorHex = ignore,
    Object? moodLevel = ignore,
    Object? title = ignore,
    Object? body = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (date != ignore) 1: date as String?,
        if (dateLabel != ignore) 2: dateLabel as String?,
        if (emoji != ignore) 3: emoji as String?,
        if (emojiColorHex != ignore) 4: emojiColorHex as int?,
        if (moodLevel != ignore) 5: moodLevel as int?,
        if (title != ignore) 6: title as String?,
        if (body != ignore) 7: body as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension DiaryEntryQueryBuilderUpdate
    on QueryBuilder<DiaryEntry, DiaryEntry, QOperations> {
  _DiaryEntryQueryUpdate get updateFirst =>
      _DiaryEntryQueryBuilderUpdateImpl(this, limit: 1);

  _DiaryEntryQueryUpdate get updateAll =>
      _DiaryEntryQueryBuilderUpdateImpl(this);
}

extension DiaryEntryQueryFilter
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLabelGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLabelGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLabelLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLabelLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLabelBetween(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLabelStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLabelEndsWith(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLabelContains(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> dateLabelMatches(
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

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  dateLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> emojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiColorHexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiColorHexGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiColorHexGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiColorHexLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiColorHexLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  emojiColorHexBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodLevelEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  moodLevelGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  moodLevelGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodLevelLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  moodLevelLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> moodLevelBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  titleGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  titleLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  bodyGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition>
  bodyLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterFilterCondition> bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }
}

extension DiaryEntryQueryObject
    on QueryBuilder<DiaryEntry, DiaryEntry, QFilterCondition> {}

extension DiaryEntryQuerySortBy
    on QueryBuilder<DiaryEntry, DiaryEntry, QSortBy> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDateDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDateLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByDateLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByEmoji({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByEmojiDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByEmojiColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByEmojiColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByMoodLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByTitleDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByBody({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> sortByBodyDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DiaryEntryQuerySortThenBy
    on QueryBuilder<DiaryEntry, DiaryEntry, QSortThenBy> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDateDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDateLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByDateLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByEmoji({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByEmojiDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByEmojiColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByEmojiColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByMoodLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByTitleDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByBody({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterSortBy> thenByBodyDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DiaryEntryQueryWhereDistinct
    on QueryBuilder<DiaryEntry, DiaryEntry, QDistinct> {
  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct> distinctByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct> distinctByDateLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct> distinctByEmoji({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct>
  distinctByEmojiColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct> distinctByMoodLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryEntry, DiaryEntry, QAfterDistinct> distinctByBody({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }
}

extension DiaryEntryQueryProperty1
    on QueryBuilder<DiaryEntry, DiaryEntry, QProperty> {
  QueryBuilder<DiaryEntry, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DiaryEntry, String, QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DiaryEntry, String, QAfterProperty> dateLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DiaryEntry, String, QAfterProperty> emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DiaryEntry, int, QAfterProperty> emojiColorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DiaryEntry, int, QAfterProperty> moodLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DiaryEntry, String, QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DiaryEntry, String, QAfterProperty> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension DiaryEntryQueryProperty2<R>
    on QueryBuilder<DiaryEntry, R, QAfterProperty> {
  QueryBuilder<DiaryEntry, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DiaryEntry, (R, String), QAfterProperty> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DiaryEntry, (R, String), QAfterProperty> dateLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DiaryEntry, (R, String), QAfterProperty> emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DiaryEntry, (R, int), QAfterProperty> emojiColorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DiaryEntry, (R, int), QAfterProperty> moodLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DiaryEntry, (R, String), QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DiaryEntry, (R, String), QAfterProperty> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension DiaryEntryQueryProperty3<R1, R2>
    on QueryBuilder<DiaryEntry, (R1, R2), QAfterProperty> {
  QueryBuilder<DiaryEntry, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, String), QOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, String), QOperations> dateLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, String), QOperations> emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, int), QOperations> emojiColorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, int), QOperations> moodLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, String), QOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<DiaryEntry, (R1, R2, String), QOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}
