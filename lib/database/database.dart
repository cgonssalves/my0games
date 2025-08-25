import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables.dart';

part 'database.g.dart';

// enum para deixar nosso código de ordenação mais limpo e seguro
enum SortMode { az, lastAdded, firstAdded }

@DriftAccessor(tables: [Games])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(AppDatabase db) : super(db);

  // parâmetro para ordenar os resultados
  Stream<List<Game>> watchAllGamesOrdered(SortMode mode) {
    switch (mode) {
      case SortMode.az:
        // ordena pelo nome em ordem crescente (A-Z)
        return (select(games)..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])).watch();
      case SortMode.firstAdded:
        // ordena pelo ID em ordem crescente (os primeiros adicionados têm IDs menores)
        return (select(games)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])).watch();
      case SortMode.lastAdded:
      default:
        // ordena pelo ID em ordem decrescente (os últimos adicionados têm IDs maiores)
        return (select(games)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])).watch();
    }
  }

  Stream<List<Game>> watchAllGames() => select(games).watch();

  Stream<List<Game>> watchGamesByPlatforms(List<String> platforms) {
    if (platforms.isEmpty) {
      return select(games).watch(); 
    } else {
      return (select(games)..where((tbl) => tbl.platform.isIn(platforms))).watch();
    }
  }

  Future<int> insertGame(GamesCompanion game) => into(games).insert(game);
  Future<int> deleteGame(Game game) => delete(games).delete(game);
  Future<void> clearAllDataForLogout() async {
    await delete(games).go();
  }
}

@DriftDatabase(tables: [Games], daos: [GamesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(games, games.status);
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
