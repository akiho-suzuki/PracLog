// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLogCollection on Isar {
  IsarCollection<Log> get logs => this.collection();
}

const LogSchema = CollectionSchema(
  name: r'Log',
  id: 7425915233166922082,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'dateTime': PropertySchema(
      id: 1,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'durationInMin': PropertySchema(
      id: 2,
      name: r'durationInMin',
      type: IsarType.long,
    ),
    r'focus': PropertySchema(
      id: 3,
      name: r'focus',
      type: IsarType.long,
    ),
    r'goalsList': PropertySchema(
      id: 4,
      name: r'goalsList',
      type: IsarType.objectList,
      target: r'PracticeGoal',
    ),
    r'inProgress': PropertySchema(
      id: 5,
      name: r'inProgress',
      type: IsarType.bool,
    ),
    r'movementIndex': PropertySchema(
      id: 6,
      name: r'movementIndex',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'progress': PropertySchema(
      id: 8,
      name: r'progress',
      type: IsarType.long,
    ),
    r'satisfaction': PropertySchema(
      id: 9,
      name: r'satisfaction',
      type: IsarType.long,
    ),
    r'timerDataList': PropertySchema(
      id: 10,
      name: r'timerDataList',
      type: IsarType.objectList,
      target: r'TimerData',
    )
  },
  estimateSize: _logEstimateSize,
  serialize: _logSerialize,
  deserialize: _logDeserialize,
  deserializeProp: _logDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateTime': IndexSchema(
      id: -138851979697481250,
      name: r'dateTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'completed': IndexSchema(
      id: -1755850151728404861,
      name: r'completed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'piece': LinkSchema(
      id: 3424072916659111440,
      name: r'piece',
      target: r'Piece',
      single: true,
    )
  },
  embeddedSchemas: {
    r'PracticeGoal': PracticeGoalSchema,
    r'TimerData': TimerDataSchema
  },
  getId: _logGetId,
  getLinks: _logGetLinks,
  attach: _logAttach,
  version: '3.1.0+1',
);

int _logEstimateSize(
  Log object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.goalsList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PracticeGoal]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              PracticeGoalSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.timerDataList.length * 3;
  {
    final offsets = allOffsets[TimerData]!;
    for (var i = 0; i < object.timerDataList.length; i++) {
      final value = object.timerDataList[i];
      bytesCount += TimerDataSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _logSerialize(
  Log object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeDateTime(offsets[1], object.dateTime);
  writer.writeLong(offsets[2], object.durationInMin);
  writer.writeLong(offsets[3], object.focus);
  writer.writeObjectList<PracticeGoal>(
    offsets[4],
    allOffsets,
    PracticeGoalSchema.serialize,
    object.goalsList,
  );
  writer.writeBool(offsets[5], object.inProgress);
  writer.writeLong(offsets[6], object.movementIndex);
  writer.writeString(offsets[7], object.notes);
  writer.writeLong(offsets[8], object.progress);
  writer.writeLong(offsets[9], object.satisfaction);
  writer.writeObjectList<TimerData>(
    offsets[10],
    allOffsets,
    TimerDataSchema.serialize,
    object.timerDataList,
  );
}

Log _logDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Log();
  object.completed = reader.readBool(offsets[0]);
  object.dateTime = reader.readDateTime(offsets[1]);
  object.durationInMin = reader.readLongOrNull(offsets[2]);
  object.focus = reader.readLongOrNull(offsets[3]);
  object.goalsList = reader.readObjectList<PracticeGoal>(
    offsets[4],
    PracticeGoalSchema.deserialize,
    allOffsets,
    PracticeGoal(),
  );
  object.id = id;
  object.inProgress = reader.readBool(offsets[5]);
  object.movementIndex = reader.readLongOrNull(offsets[6]);
  object.notes = reader.readStringOrNull(offsets[7]);
  object.progress = reader.readLongOrNull(offsets[8]);
  object.satisfaction = reader.readLongOrNull(offsets[9]);
  object.timerDataList = reader.readObjectList<TimerData>(
        offsets[10],
        TimerDataSchema.deserialize,
        allOffsets,
        TimerData(),
      ) ??
      [];
  return object;
}

P _logDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readObjectList<PracticeGoal>(
        offset,
        PracticeGoalSchema.deserialize,
        allOffsets,
        PracticeGoal(),
      )) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readObjectList<TimerData>(
            offset,
            TimerDataSchema.deserialize,
            allOffsets,
            TimerData(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _logGetId(Log object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _logGetLinks(Log object) {
  return [object.piece];
}

void _logAttach(IsarCollection<dynamic> col, Id id, Log object) {
  object.id = id;
  object.piece.attach(col, col.isar.collection<Piece>(), r'piece', id);
}

extension LogQueryWhereSort on QueryBuilder<Log, Log, QWhere> {
  QueryBuilder<Log, Log, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Log, Log, QAfterWhere> anyDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateTime'),
      );
    });
  }

  QueryBuilder<Log, Log, QAfterWhere> anyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completed'),
      );
    });
  }
}

extension LogQueryWhere on QueryBuilder<Log, Log, QWhereClause> {
  QueryBuilder<Log, Log, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> dateTimeEqualTo(DateTime dateTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateTime',
        value: [dateTime],
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> dateTimeNotEqualTo(
      DateTime dateTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [],
              upper: [dateTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [dateTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [dateTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateTime',
              lower: [],
              upper: [dateTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> dateTimeGreaterThan(
    DateTime dateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateTime',
        lower: [dateTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> dateTimeLessThan(
    DateTime dateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateTime',
        lower: [],
        upper: [dateTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> dateTimeBetween(
    DateTime lowerDateTime,
    DateTime upperDateTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateTime',
        lower: [lowerDateTime],
        includeLower: includeLower,
        upper: [upperDateTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> completedEqualTo(bool completed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completed',
        value: [completed],
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterWhereClause> completedNotEqualTo(
      bool completed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [completed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completed',
              lower: [],
              upper: [completed],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LogQueryFilter on QueryBuilder<Log, Log, QFilterCondition> {
  QueryBuilder<Log, Log, QAfterFilterCondition> completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> dateTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> dateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> dateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> dateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> durationInMinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationInMin',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> durationInMinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationInMin',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> durationInMinEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInMin',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> durationInMinGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInMin',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> durationInMinLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInMin',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> durationInMinBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInMin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> focusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'focus',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> focusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'focus',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> focusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> focusGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> focusLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focus',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> focusBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'goalsList',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'goalsList',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> inProgressEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> movementIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'movementIndex',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> movementIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'movementIndex',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> movementIndexEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movementIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> movementIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movementIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> movementIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movementIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> movementIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movementIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> progressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'progress',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> progressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'progress',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> progressEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> progressGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> progressLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> progressBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> satisfactionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'satisfaction',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> satisfactionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'satisfaction',
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> satisfactionEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'satisfaction',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> satisfactionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'satisfaction',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> satisfactionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'satisfaction',
        value: value,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> satisfactionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'satisfaction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timerDataList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timerDataList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timerDataList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timerDataList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timerDataList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'timerDataList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension LogQueryObject on QueryBuilder<Log, Log, QFilterCondition> {
  QueryBuilder<Log, Log, QAfterFilterCondition> goalsListElement(
      FilterQuery<PracticeGoal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'goalsList');
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> timerDataListElement(
      FilterQuery<TimerData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'timerDataList');
    });
  }
}

extension LogQueryLinks on QueryBuilder<Log, Log, QFilterCondition> {
  QueryBuilder<Log, Log, QAfterFilterCondition> piece(FilterQuery<Piece> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'piece');
    });
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> pieceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'piece', 0, true, 0, true);
    });
  }
}

extension LogQuerySortBy on QueryBuilder<Log, Log, QSortBy> {
  QueryBuilder<Log, Log, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByDurationInMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMin', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByDurationInMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMin', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByInProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inProgress', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByInProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inProgress', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByMovementIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementIndex', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByMovementIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementIndex', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortBySatisfaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfaction', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortBySatisfactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfaction', Sort.desc);
    });
  }
}

extension LogQuerySortThenBy on QueryBuilder<Log, Log, QSortThenBy> {
  QueryBuilder<Log, Log, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByDurationInMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMin', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByDurationInMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMin', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focus', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByInProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inProgress', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByInProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inProgress', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByMovementIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementIndex', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByMovementIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementIndex', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenBySatisfaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfaction', Sort.asc);
    });
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenBySatisfactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfaction', Sort.desc);
    });
  }
}

extension LogQueryWhereDistinct on QueryBuilder<Log, Log, QDistinct> {
  QueryBuilder<Log, Log, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByDurationInMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInMin');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focus');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByInProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inProgress');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByMovementIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movementIndex');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<Log, Log, QDistinct> distinctBySatisfaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'satisfaction');
    });
  }
}

extension LogQueryProperty on QueryBuilder<Log, Log, QQueryProperty> {
  QueryBuilder<Log, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Log, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<Log, DateTime, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<Log, int?, QQueryOperations> durationInMinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInMin');
    });
  }

  QueryBuilder<Log, int?, QQueryOperations> focusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focus');
    });
  }

  QueryBuilder<Log, List<PracticeGoal>?, QQueryOperations> goalsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalsList');
    });
  }

  QueryBuilder<Log, bool, QQueryOperations> inProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inProgress');
    });
  }

  QueryBuilder<Log, int?, QQueryOperations> movementIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movementIndex');
    });
  }

  QueryBuilder<Log, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Log, int?, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<Log, int?, QQueryOperations> satisfactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'satisfaction');
    });
  }

  QueryBuilder<Log, List<TimerData>, QQueryOperations> timerDataListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timerDataList');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TimerDataSchema = Schema(
  name: r'TimerData',
  id: -6400389746147121307,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'startTime': PropertySchema(
      id: 1,
      name: r'startTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _timerDataEstimateSize,
  serialize: _timerDataSerialize,
  deserialize: _timerDataDeserialize,
  deserializeProp: _timerDataDeserializeProp,
);

int _timerDataEstimateSize(
  TimerData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _timerDataSerialize(
  TimerData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endTime);
  writer.writeDateTime(offsets[1], object.startTime);
}

TimerData _timerDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TimerData();
  object.endTime = reader.readDateTimeOrNull(offsets[0]);
  object.startTime = reader.readDateTime(offsets[1]);
  return object;
}

P _timerDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TimerDataQueryFilter
    on QueryBuilder<TimerData, TimerData, QFilterCondition> {
  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> endTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> startTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerData, TimerData, QAfterFilterCondition> startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TimerDataQueryObject
    on QueryBuilder<TimerData, TimerData, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PracticeGoalSchema = Schema(
  name: r'PracticeGoal',
  id: -7736456348212621229,
  properties: {
    r'isTicked': PropertySchema(
      id: 0,
      name: r'isTicked',
      type: IsarType.bool,
    ),
    r'text': PropertySchema(
      id: 1,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _practiceGoalEstimateSize,
  serialize: _practiceGoalSerialize,
  deserialize: _practiceGoalDeserialize,
  deserializeProp: _practiceGoalDeserializeProp,
);

int _practiceGoalEstimateSize(
  PracticeGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _practiceGoalSerialize(
  PracticeGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isTicked);
  writer.writeString(offsets[1], object.text);
}

PracticeGoal _practiceGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PracticeGoal();
  object.isTicked = reader.readBool(offsets[0]);
  object.text = reader.readString(offsets[1]);
  return object;
}

P _practiceGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PracticeGoalQueryFilter
    on QueryBuilder<PracticeGoal, PracticeGoal, QFilterCondition> {
  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition>
      isTickedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTicked',
        value: value,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<PracticeGoal, PracticeGoal, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension PracticeGoalQueryObject
    on QueryBuilder<PracticeGoal, PracticeGoal, QFilterCondition> {}
