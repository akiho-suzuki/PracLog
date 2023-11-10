// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piece.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPieceCollection on Isar {
  IsarCollection<Piece> get pieces => this.collection();
}

const PieceSchema = CollectionSchema(
  name: r'Piece',
  id: -454604818156434898,
  properties: {
    r'composer': PropertySchema(
      id: 0,
      name: r'composer',
      type: IsarType.string,
    ),
    r'isCurrent': PropertySchema(
      id: 1,
      name: r'isCurrent',
      type: IsarType.bool,
    ),
    r'movements': PropertySchema(
      id: 2,
      name: r'movements',
      type: IsarType.stringList,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _pieceEstimateSize,
  serialize: _pieceSerialize,
  deserialize: _pieceDeserialize,
  deserializeProp: _pieceDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'composer': IndexSchema(
      id: 7774402279906236920,
      name: r'composer',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'composer',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'isCurrent': IndexSchema(
      id: -8698398489692661776,
      name: r'isCurrent',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isCurrent',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'logs': LinkSchema(
      id: 7118316107746656965,
      name: r'logs',
      target: r'Log',
      single: false,
      linkName: r'piece',
    )
  },
  embeddedSchemas: {},
  getId: _pieceGetId,
  getLinks: _pieceGetLinks,
  attach: _pieceAttach,
  version: '3.1.0+1',
);

int _pieceEstimateSize(
  Piece object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.composer.length * 3;
  {
    final list = object.movements;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _pieceSerialize(
  Piece object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.composer);
  writer.writeBool(offsets[1], object.isCurrent);
  writer.writeStringList(offsets[2], object.movements);
  writer.writeString(offsets[3], object.title);
}

Piece _pieceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Piece();
  object.composer = reader.readString(offsets[0]);
  object.id = id;
  object.isCurrent = reader.readBool(offsets[1]);
  object.movements = reader.readStringList(offsets[2]);
  object.title = reader.readString(offsets[3]);
  return object;
}

P _pieceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pieceGetId(Piece object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pieceGetLinks(Piece object) {
  return [object.logs];
}

void _pieceAttach(IsarCollection<dynamic> col, Id id, Piece object) {
  object.id = id;
  object.logs.attach(col, col.isar.collection<Log>(), r'logs', id);
}

extension PieceQueryWhereSort on QueryBuilder<Piece, Piece, QWhere> {
  QueryBuilder<Piece, Piece, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhere> anyIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isCurrent'),
      );
    });
  }
}

extension PieceQueryWhere on QueryBuilder<Piece, Piece, QWhereClause> {
  QueryBuilder<Piece, Piece, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Piece, Piece, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> idBetween(
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

  QueryBuilder<Piece, Piece, QAfterWhereClause> titleEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> titleNotEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> composerEqualTo(
      String composer) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'composer',
        value: [composer],
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> composerNotEqualTo(
      String composer) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'composer',
              lower: [],
              upper: [composer],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'composer',
              lower: [composer],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'composer',
              lower: [composer],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'composer',
              lower: [],
              upper: [composer],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> isCurrentEqualTo(
      bool isCurrent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isCurrent',
        value: [isCurrent],
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterWhereClause> isCurrentNotEqualTo(
      bool isCurrent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isCurrent',
              lower: [],
              upper: [isCurrent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isCurrent',
              lower: [isCurrent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isCurrent',
              lower: [isCurrent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isCurrent',
              lower: [],
              upper: [isCurrent],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PieceQueryFilter on QueryBuilder<Piece, Piece, QFilterCondition> {
  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'composer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'composer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'composer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'composer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'composer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'composer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'composer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'composer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'composer',
        value: '',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> composerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'composer',
        value: '',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Piece, Piece, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Piece, Piece, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Piece, Piece, QAfterFilterCondition> isCurrentEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCurrent',
        value: value,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'movements',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'movements',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movements',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'movements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'movements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'movements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'movements',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movements',
        value: '',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition>
      movementsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'movements',
        value: '',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movements',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movements',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movements',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movements',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movements',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> movementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movements',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension PieceQueryObject on QueryBuilder<Piece, Piece, QFilterCondition> {}

extension PieceQueryLinks on QueryBuilder<Piece, Piece, QFilterCondition> {
  QueryBuilder<Piece, Piece, QAfterFilterCondition> logs(FilterQuery<Log> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'logs');
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> logsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'logs', length, true, length, true);
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> logsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'logs', 0, true, 0, true);
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> logsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'logs', 0, false, 999999, true);
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> logsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'logs', 0, true, length, include);
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> logsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'logs', length, include, 999999, true);
    });
  }

  QueryBuilder<Piece, Piece, QAfterFilterCondition> logsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'logs', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PieceQuerySortBy on QueryBuilder<Piece, Piece, QSortBy> {
  QueryBuilder<Piece, Piece, QAfterSortBy> sortByComposer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> sortByComposerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.desc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> sortByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> sortByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PieceQuerySortThenBy on QueryBuilder<Piece, Piece, QSortThenBy> {
  QueryBuilder<Piece, Piece, QAfterSortBy> thenByComposer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenByComposerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'composer', Sort.desc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Piece, Piece, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PieceQueryWhereDistinct on QueryBuilder<Piece, Piece, QDistinct> {
  QueryBuilder<Piece, Piece, QDistinct> distinctByComposer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'composer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Piece, Piece, QDistinct> distinctByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCurrent');
    });
  }

  QueryBuilder<Piece, Piece, QDistinct> distinctByMovements() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movements');
    });
  }

  QueryBuilder<Piece, Piece, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension PieceQueryProperty on QueryBuilder<Piece, Piece, QQueryProperty> {
  QueryBuilder<Piece, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Piece, String, QQueryOperations> composerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'composer');
    });
  }

  QueryBuilder<Piece, bool, QQueryOperations> isCurrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCurrent');
    });
  }

  QueryBuilder<Piece, List<String>?, QQueryOperations> movementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movements');
    });
  }

  QueryBuilder<Piece, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
