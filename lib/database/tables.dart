import 'package:drift/drift.dart';

class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  TextColumn get name => text()();
  TextColumn get coverUrl => text()(); 
  TextColumn get platform => text()();
  TextColumn get status => text().withDefault(const Constant('na biblioteca'))();
  IntColumn get hoursPlayed => integer().nullable()();

}
