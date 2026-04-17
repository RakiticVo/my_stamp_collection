import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';
import 'db_migrator.dart';

class AppDatabase {
  AppDatabase();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final String dbPath = await getDatabasesPath();
    final String fullPath = path.join(dbPath, AppConstants.databaseName);

    _database = await openDatabase(
      fullPath,
      version: AppConstants.databaseVersion,
      onCreate: DbMigrator.onCreate,
      onUpgrade: DbMigrator.onUpgrade,
    );

    return _database!;
  }
}
