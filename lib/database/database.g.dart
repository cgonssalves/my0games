// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
mixin _$GamesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _coverUrlMeta =
      const VerificationMeta('coverUrl');
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
      'cover_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _platformMeta =
      const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
      'platform', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('na biblioteca'));
  static const VerificationMeta _hoursPlayedMeta =
      const VerificationMeta('hoursPlayed');
  @override
  late final GeneratedColumn<int> hoursPlayed = GeneratedColumn<int>(
      'hours_played', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, coverUrl, platform, status, hoursPlayed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(Insertable<Game> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(_coverUrlMeta,
          coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta));
    } else if (isInserting) {
      context.missing(_coverUrlMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('hours_played')) {
      context.handle(
          _hoursPlayedMeta,
          hoursPlayed.isAcceptableOrUnknown(
              data['hours_played']!, _hoursPlayedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      coverUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_url'])!,
      platform: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      hoursPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hours_played']),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final String name;
  final String coverUrl;
  final String platform;
  final String status;
  final int? hoursPlayed;
  const Game(
      {required this.id,
      required this.name,
      required this.coverUrl,
      required this.platform,
      required this.status,
      this.hoursPlayed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['cover_url'] = Variable<String>(coverUrl);
    map['platform'] = Variable<String>(platform);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || hoursPlayed != null) {
      map['hours_played'] = Variable<int>(hoursPlayed);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      name: Value(name),
      coverUrl: Value(coverUrl),
      platform: Value(platform),
      status: Value(status),
      hoursPlayed: hoursPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursPlayed),
    );
  }

  factory Game.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coverUrl: serializer.fromJson<String>(json['coverUrl']),
      platform: serializer.fromJson<String>(json['platform']),
      status: serializer.fromJson<String>(json['status']),
      hoursPlayed: serializer.fromJson<int?>(json['hoursPlayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'coverUrl': serializer.toJson<String>(coverUrl),
      'platform': serializer.toJson<String>(platform),
      'status': serializer.toJson<String>(status),
      'hoursPlayed': serializer.toJson<int?>(hoursPlayed),
    };
  }

  Game copyWith(
          {int? id,
          String? name,
          String? coverUrl,
          String? platform,
          String? status,
          Value<int?> hoursPlayed = const Value.absent()}) =>
      Game(
        id: id ?? this.id,
        name: name ?? this.name,
        coverUrl: coverUrl ?? this.coverUrl,
        platform: platform ?? this.platform,
        status: status ?? this.status,
        hoursPlayed: hoursPlayed.present ? hoursPlayed.value : this.hoursPlayed,
      );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      platform: data.platform.present ? data.platform.value : this.platform,
      status: data.status.present ? data.status.value : this.status,
      hoursPlayed:
          data.hoursPlayed.present ? data.hoursPlayed.value : this.hoursPlayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('platform: $platform, ')
          ..write('status: $status, ')
          ..write('hoursPlayed: $hoursPlayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, coverUrl, platform, status, hoursPlayed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.name == this.name &&
          other.coverUrl == this.coverUrl &&
          other.platform == this.platform &&
          other.status == this.status &&
          other.hoursPlayed == this.hoursPlayed);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> coverUrl;
  final Value<String> platform;
  final Value<String> status;
  final Value<int?> hoursPlayed;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.platform = const Value.absent(),
    this.status = const Value.absent(),
    this.hoursPlayed = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String coverUrl,
    required String platform,
    this.status = const Value.absent(),
    this.hoursPlayed = const Value.absent(),
  })  : name = Value(name),
        coverUrl = Value(coverUrl),
        platform = Value(platform);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? coverUrl,
    Expression<String>? platform,
    Expression<String>? status,
    Expression<int>? hoursPlayed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (platform != null) 'platform': platform,
      if (status != null) 'status': status,
      if (hoursPlayed != null) 'hours_played': hoursPlayed,
    });
  }

  GamesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? coverUrl,
      Value<String>? platform,
      Value<String>? status,
      Value<int?>? hoursPlayed}) {
    return GamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (hoursPlayed.present) {
      map['hours_played'] = Variable<int>(hoursPlayed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('platform: $platform, ')
          ..write('status: $status, ')
          ..write('hoursPlayed: $hoursPlayed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final GamesDao gamesDao = GamesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games];
}

typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  required String name,
  required String coverUrl,
  required String platform,
  Value<String> status,
  Value<int?> hoursPlayed,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> coverUrl,
  Value<String> platform,
  Value<String> status,
  Value<int?> hoursPlayed,
});

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hoursPlayed => $composableBuilder(
      column: $table.hoursPlayed, builder: (column) => ColumnFilters(column));
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hoursPlayed => $composableBuilder(
      column: $table.hoursPlayed, builder: (column) => ColumnOrderings(column));
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get hoursPlayed => $composableBuilder(
      column: $table.hoursPlayed, builder: (column) => column);
}

class $$GamesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, BaseReferences<_$AppDatabase, $GamesTable, Game>),
    Game,
    PrefetchHooks Function()> {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> coverUrl = const Value.absent(),
            Value<String> platform = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> hoursPlayed = const Value.absent(),
          }) =>
              GamesCompanion(
            id: id,
            name: name,
            coverUrl: coverUrl,
            platform: platform,
            status: status,
            hoursPlayed: hoursPlayed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String coverUrl,
            required String platform,
            Value<String> status = const Value.absent(),
            Value<int?> hoursPlayed = const Value.absent(),
          }) =>
              GamesCompanion.insert(
            id: id,
            name: name,
            coverUrl: coverUrl,
            platform: platform,
            status: status,
            hoursPlayed: hoursPlayed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GamesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, BaseReferences<_$AppDatabase, $GamesTable, Game>),
    Game,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
}
