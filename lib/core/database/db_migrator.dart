import 'package:sqflite/sqflite.dart';

class DbMigrator {
  const DbMigrator._();

  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE collectors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE collections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        collector_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        current_value REAL NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY(collector_id) REFERENCES collectors(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE stamps(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        collection_id INTEGER NOT NULL,
        category TEXT NOT NULL DEFAULT 'General',
        title TEXT NOT NULL,
        country TEXT NOT NULL,
        year INTEGER NOT NULL,
        denomination REAL NOT NULL,
        condition TEXT NOT NULL,
        is_nft INTEGER NOT NULL DEFAULT 0,
        image_path TEXT,
        description TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY(collection_id) REFERENCES collections(id)
      )
    ''');

    await db.execute('CREATE INDEX idx_stamps_year ON stamps(year)');
    await db.execute('CREATE INDEX idx_stamps_country ON stamps(country)');
    await db.execute('CREATE INDEX idx_stamps_condition ON stamps(condition)');
    await db.execute('CREATE INDEX idx_stamps_category ON stamps(category)');

    final int now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('collectors', {
      'id': 1,
      'name': 'Default Collector',
      'created_at': now,
    });

    await db.insert('collections', {
      'id': 1,
      'collector_id': 1,
      'name': 'My Vault',
      'current_value': 0,
      'created_at': now,
    });

    await db.insert('collections', {
      'id': 2,
      'collector_id': 1,
      'name': 'Travel Diary',
      'current_value': 0,
      'created_at': now,
    });

    await db.insert('collections', {
      'id': 3,
      'collector_id': 1,
      'name': 'Rare Finds',
      'current_value': 0,
      'created_at': now,
    });
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE stamps ADD COLUMN category TEXT NOT NULL DEFAULT 'General'",
      );
      await db.execute('CREATE INDEX idx_stamps_category ON stamps(category)');

      final int now = DateTime.now().millisecondsSinceEpoch;
      await db.insert('collections', {
        'id': 2,
        'collector_id': 1,
        'name': 'Travel Diary',
        'current_value': 0,
        'created_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert('collections', {
        'id': 3,
        'collector_id': 1,
        'name': 'Rare Finds',
        'current_value': 0,
        'created_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE stamps ADD COLUMN description TEXT",
      );
    }
  }
}
