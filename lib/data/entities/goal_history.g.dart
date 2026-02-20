// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGoalHistoryCollection on Isar {
  IsarCollection<GoalHistory> get goalHistorys => this.collection();
}

const GoalHistorySchema = CollectionSchema(
  name: r'GoalHistory',
  id: -9009030071394641627,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'delta': PropertySchema(
      id: 1,
      name: r'delta',
      type: IsarType.long,
    ),
    r'goalId': PropertySchema(
      id: 2,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'progress': PropertySchema(
      id: 3,
      name: r'progress',
      type: IsarType.long,
    )
  },
  estimateSize: _goalHistoryEstimateSize,
  serialize: _goalHistorySerialize,
  deserialize: _goalHistoryDeserialize,
  deserializeProp: _goalHistoryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _goalHistoryGetId,
  getLinks: _goalHistoryGetLinks,
  attach: _goalHistoryAttach,
  version: '3.1.0+1',
);

int _goalHistoryEstimateSize(
  GoalHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _goalHistorySerialize(
  GoalHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.delta);
  writer.writeLong(offsets[2], object.goalId);
  writer.writeLong(offsets[3], object.progress);
}

GoalHistory _goalHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GoalHistory();
  object.date = reader.readDateTime(offsets[0]);
  object.delta = reader.readLong(offsets[1]);
  object.goalId = reader.readLong(offsets[2]);
  object.id = id;
  object.progress = reader.readLong(offsets[3]);
  return object;
}

P _goalHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _goalHistoryGetId(GoalHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goalHistoryGetLinks(GoalHistory object) {
  return [];
}

void _goalHistoryAttach(
    IsarCollection<dynamic> col, Id id, GoalHistory object) {
  object.id = id;
}

extension GoalHistoryQueryWhereSort
    on QueryBuilder<GoalHistory, GoalHistory, QWhere> {
  QueryBuilder<GoalHistory, GoalHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GoalHistoryQueryWhere
    on QueryBuilder<GoalHistory, GoalHistory, QWhereClause> {
  QueryBuilder<GoalHistory, GoalHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<GoalHistory, GoalHistory, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterWhereClause> idBetween(
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
}

extension GoalHistoryQueryFilter
    on QueryBuilder<GoalHistory, GoalHistory, QFilterCondition> {
  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> deltaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delta',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition>
      deltaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'delta',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> deltaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'delta',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> deltaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'delta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> goalIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition>
      goalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> goalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> goalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> progressEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition>
      progressGreaterThan(
    int value, {
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

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition>
      progressLessThan(
    int value, {
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

  QueryBuilder<GoalHistory, GoalHistory, QAfterFilterCondition> progressBetween(
    int lower,
    int upper, {
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
}

extension GoalHistoryQueryObject
    on QueryBuilder<GoalHistory, GoalHistory, QFilterCondition> {}

extension GoalHistoryQueryLinks
    on QueryBuilder<GoalHistory, GoalHistory, QFilterCondition> {}

extension GoalHistoryQuerySortBy
    on QueryBuilder<GoalHistory, GoalHistory, QSortBy> {
  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }
}

extension GoalHistoryQuerySortThenBy
    on QueryBuilder<GoalHistory, GoalHistory, QSortThenBy> {
  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }
}

extension GoalHistoryQueryWhereDistinct
    on QueryBuilder<GoalHistory, GoalHistory, QDistinct> {
  QueryBuilder<GoalHistory, GoalHistory, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QDistinct> distinctByDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delta');
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QDistinct> distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<GoalHistory, GoalHistory, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }
}

extension GoalHistoryQueryProperty
    on QueryBuilder<GoalHistory, GoalHistory, QQueryProperty> {
  QueryBuilder<GoalHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GoalHistory, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<GoalHistory, int, QQueryOperations> deltaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delta');
    });
  }

  QueryBuilder<GoalHistory, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<GoalHistory, int, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }
}
