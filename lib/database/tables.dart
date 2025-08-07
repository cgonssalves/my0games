import 'package:drift/drift.dart';

// Nome da classe é no plural (Games)
class Games extends Table {
  // id será a chave primária, auto-incrementada
  IntColumn get id => integer().autoIncrement()();
  
  // Colunas para guardar as informações do jogo
  TextColumn get name => text()();
  TextColumn get coverUrl => text()(); // O mais importante para resolver seu bug!
  TextColumn get platform => text()();
}