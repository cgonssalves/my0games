// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
mixin _$GamesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
}
mixin _$MediaDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $MediaItemsTable get mediaItems => attachedDatabase.mediaItems;
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

class $MediaItemsTable extends MediaItems
    with TableInfo<$MediaItemsTable, MediaItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
      'game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES games (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, imagePath, gameId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_items';
  @override
  VerificationContext validateIntegrity(Insertable<MediaItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}game_id'])!,
    );
  }

  @override
  $MediaItemsTable createAlias(String alias) {
    return $MediaItemsTable(attachedDatabase, alias);
  }
}

class MediaItem extends DataClass implements Insertable<MediaItem> {
  final int id;
  final String imagePath;
  final int gameId;
  const MediaItem(
      {required this.id, required this.imagePath, required this.gameId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['image_path'] = Variable<String>(imagePath);
    map['game_id'] = Variable<int>(gameId);
    return map;
  }

  MediaItemsCompanion toCompanion(bool nullToAbsent) {
    return MediaItemsCompanion(
      id: Value(id),
      imagePath: Value(imagePath),
      gameId: Value(gameId),
    );
  }

  factory MediaItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaItem(
      id: serializer.fromJson<int>(json['id']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      gameId: serializer.fromJson<int>(json['gameId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'imagePath': serializer.toJson<String>(imagePath),
      'gameId': serializer.toJson<int>(gameId),
    };
  }

  MediaItem copyWith({int? id, String? imagePath, int? gameId}) => MediaItem(
        id: id ?? this.id,
        imagePath: imagePath ?? this.imagePath,
        gameId: gameId ?? this.gameId,
      );
  MediaItem copyWithCompanion(MediaItemsCompanion data) {
    return MediaItem(
      id: data.id.present ? data.id.value : this.id,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaItem(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('gameId: $gameId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, imagePath, gameId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaItem &&
          other.id == this.id &&
          other.imagePath == this.imagePath &&
          other.gameId == this.gameId);
}

class MediaItemsCompanion extends UpdateCompanion<MediaItem> {
  final Value<int> id;
  final Value<String> imagePath;
  final Value<int> gameId;
  const MediaItemsCompanion({
    this.id = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.gameId = const Value.absent(),
  });
  MediaItemsCompanion.insert({
    this.id = const Value.absent(),
    required String imagePath,
    required int gameId,
  })  : imagePath = Value(imagePath),
        gameId = Value(gameId);
  static Insertable<MediaItem> custom({
    Expression<int>? id,
    Expression<String>? imagePath,
    Expression<int>? gameId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imagePath != null) 'image_path': imagePath,
      if (gameId != null) 'game_id': gameId,
    });
  }

  MediaItemsCompanion copyWith(
      {Value<int>? id, Value<String>? imagePath, Value<int>? gameId}) {
    return MediaItemsCompanion(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      gameId: gameId ?? this.gameId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaItemsCompanion(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('gameId: $gameId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $MediaItemsTable mediaItems = $MediaItemsTable(this);
  late final GamesDao gamesDao = GamesDao(this as AppDatabase);
  late final MediaDao mediaDao = MediaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games, mediaItems];
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

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaItemsTable, List<MediaItem>>
      _mediaItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.mediaItems,
          aliasName: $_aliasNameGenerator(db.games.id, db.mediaItems.gameId));

  $$MediaItemsTableProcessedTableManager get mediaItemsRefs {
    final manager = $$MediaItemsTableTableManager($_db, $_db.mediaItems)
        .filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  Expression<bool> mediaItemsRefs(
      Expression<bool> Function($$MediaItemsTableFilterComposer f) f) {
    final $$MediaItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mediaItems,
        getReferencedColumn: (t) => t.gameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MediaItemsTableFilterComposer(
              $db: $db,
              $table: $db.mediaItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  Expression<T> mediaItemsRefs<T extends Object>(
      Expression<T> Function($$MediaItemsTableAnnotationComposer a) f) {
    final $$MediaItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mediaItems,
        getReferencedColumn: (t) => t.gameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MediaItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.mediaItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
    (Game, $$GamesTableReferences),
    Game,
    PrefetchHooks Function({bool mediaItemsRefs})> {
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
              .map((e) =>
                  (e.readTable(table), $$GamesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mediaItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaItemsRefs) db.mediaItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaItemsRefs)
                    await $_getPrefetchedData<Game, $GamesTable, MediaItem>(
                        currentTable: table,
                        referencedTable:
                            $$GamesTableReferences._mediaItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GamesTableReferences(db, table, p0)
                                .mediaItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gameId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Game, $$GamesTableReferences),
    Game,
    PrefetchHooks Function({bool mediaItemsRefs})>;
typedef $$MediaItemsTableCreateCompanionBuilder = MediaItemsCompanion Function({
  Value<int> id,
  required String imagePath,
  required int gameId,
});
typedef $$MediaItemsTableUpdateCompanionBuilder = MediaItemsCompanion Function({
  Value<int> id,
  Value<String> imagePath,
  Value<int> gameId,
});

final class $$MediaItemsTableReferences
    extends BaseReferences<_$AppDatabase, $MediaItemsTable, MediaItem> {
  $$MediaItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games
      .createAlias($_aliasNameGenerator(db.mediaItems.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager($_db, $_db.games)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MediaItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaItemsTable> {
  $$MediaItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableFilterComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaItemsTable> {
  $$MediaItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableOrderingComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaItemsTable> {
  $$MediaItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gameId,
        referencedTable: $db.games,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GamesTableAnnotationComposer(
              $db: $db,
              $table: $db.games,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MediaItemsTable,
    MediaItem,
    $$MediaItemsTableFilterComposer,
    $$MediaItemsTableOrderingComposer,
    $$MediaItemsTableAnnotationComposer,
    $$MediaItemsTableCreateCompanionBuilder,
    $$MediaItemsTableUpdateCompanionBuilder,
    (MediaItem, $$MediaItemsTableReferences),
    MediaItem,
    PrefetchHooks Function({bool gameId})> {
  $$MediaItemsTableTableManager(_$AppDatabase db, $MediaItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<int> gameId = const Value.absent(),
          }) =>
              MediaItemsCompanion(
            id: id,
            imagePath: imagePath,
            gameId: gameId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String imagePath,
            required int gameId,
          }) =>
              MediaItemsCompanion.insert(
            id: id,
            imagePath: imagePath,
            gameId: gameId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MediaItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (gameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gameId,
                    referencedTable:
                        $$MediaItemsTableReferences._gameIdTable(db),
                    referencedColumn:
                        $$MediaItemsTableReferences._gameIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MediaItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MediaItemsTable,
    MediaItem,
    $$MediaItemsTableFilterComposer,
    $$MediaItemsTableOrderingComposer,
    $$MediaItemsTableAnnotationComposer,
    $$MediaItemsTableCreateCompanionBuilder,
    $$MediaItemsTableUpdateCompanionBuilder,
    (MediaItem, $$MediaItemsTableReferences),
    MediaItem,
    PrefetchHooks Function({bool gameId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$MediaItemsTableTableManager get mediaItems =>
      $$MediaItemsTableTableManager(_db, _db.mediaItems);
}
