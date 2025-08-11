import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables.dart';

part 'database.g.dart';

@DriftAccessor(tables: [Games])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(AppDatabase db) : super(db);

  Stream<List<Game>> watchGamesByPlatform(String platform) {
    return (select(games)..where((tbl) => tbl.platform.equals(platform))).watch();
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
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
