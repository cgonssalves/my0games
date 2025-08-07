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

  // Função para pegar TODOS os jogos em tempo real (Stream)
  Stream<List<Game>> watchAllGames() => select(games).watch();

  // Função para inserir um novo jogo
  Future<int> insertGame(Game game) => into(games).insert(game);

  // Função para deletar um jogo
  Future<int> deleteGame(Game game) => delete(games).delete(game);
}

// O banco de dados principal
@DriftDatabase(tables: [Games], daos: [GamesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// Abre a conexão com o arquivo do banco de dados no dispositivo
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
