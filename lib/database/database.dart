import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables.dart';

part 'database.g.dart';

enum SortMode { az, lastAdded, firstAdded, platinados, wishlist }

@DriftAccessor(tables: [Games])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(AppDatabase db) : super(db);

  Stream<List<Game>> watchAllGamesOrdered(SortMode mode) {
    if (mode == SortMode.wishlist) {
      return (select(games)..where((tbl) => tbl.status.equals('lista de desejos'))
        ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
        .watch();
    }
    
    final query = select(games)..where((tbl) => tbl.status.isNotIn(['lista de desejos']));

    switch (mode) {
      case SortMode.az:
        query.orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]);
        break;
      case SortMode.firstAdded:
        query.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)]);
        break;
      case SortMode.platinados:
        final statusOrder = const CustomExpression<int>(
          "CASE status "
          "WHEN 'platinado' THEN 1 "
          "WHEN 'zerado' THEN 2 "
          "WHEN 'jogando' THEN 3 "
          "WHEN 'na biblioteca' THEN 4 "
          "ELSE 5 END"
        );
        query.orderBy([
          (t) => OrderingTerm(expression: statusOrder),
          (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
        ]);
        break;
      case SortMode.lastAdded:
      default:
        query.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]);
        break;
    }
    
    return query.watch();
  }

  Stream<List<Game>> watchAllGames() => select(games).watch();
  Stream<List<Game>> watchGamesByPlatforms(List<String> platforms) {
    if (platforms.isEmpty) return select(games).watch(); 
    return (select(games)..where((tbl) => tbl.platform.isIn(platforms))).watch();
  }
  Future<int> insertGame(GamesCompanion game) => into(games).insert(game);
  Future<int> deleteGame(Game game) => delete(games).delete(game);
  Future<void> clearAllDataForLogout() async => await delete(games).go();
}

@DriftDatabase(tables: [Games], daos: [GamesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  // --- MUDANÇA 1: Aumentamos a versão ---
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async => await m.createAll(),
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(games, games.status);
        }
        if (from < 3) {
          await m.addColumn(games, games.hoursPlayed);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
