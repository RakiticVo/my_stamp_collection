import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/collection_summary.dart';
import '../../domain/entities/stamp_filter.dart';
import '../models/stamp_item_model.dart';

class CollectionLocalDataSource {
  CollectionLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<List<StampItemModel>> getStamps() async {
    final Database db = await _appDatabase.database;
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
      SELECT s.*, c.name AS collection_name
      FROM stamps s
      LEFT JOIN collections c ON c.id = s.collection_id
      ORDER BY s.created_at DESC
      ''',
    );

    return rows.map(StampItemModel.fromMap).toList(growable: false);
  }

  Future<void> addStamp(StampItemModel model) async {
    final Database db = await _appDatabase.database;
    await db.insert(
      'stamps',
      model.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<StampItemModel>> filterStamps(StampFilter filter) async {
    final Database db = await _appDatabase.database;

    final List<String> whereClauses = <String>[];
    final List<Object?> args = <Object?>[];

    if ((filter.query ?? '').isNotEmpty) {
      whereClauses.add('(s.title LIKE ? OR s.country LIKE ? OR s.category LIKE ?)');
      final String q = '%${filter.query}%';
      args
        ..add(q)
        ..add(q)
        ..add(q);
    }

    if (filter.fromYear != null) {
      whereClauses.add('s.year >= ?');
      args.add(filter.fromYear);
    }

    if (filter.toYear != null) {
      whereClauses.add('s.year <= ?');
      args.add(filter.toYear);
    }

    if (filter.collectionId != null) {
      whereClauses.add('s.collection_id = ?');
      args.add(filter.collectionId);
    }

    if (filter.category != null && filter.category!.isNotEmpty) {
      whereClauses.add('s.category = ?');
      args.add(filter.category);
    }

    if (filter.condition != null && filter.condition!.isNotEmpty) {
      whereClauses.add('s.condition = ?');
      args.add(filter.condition);
    }

    if (filter.isNft != null) {
      whereClauses.add('s.is_nft = ?');
      args.add(filter.isNft! ? 1 : 0);
    }

    final String whereSql = whereClauses.isEmpty
        ? ''
        : 'WHERE ${whereClauses.join(' AND ')}';
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
      SELECT s.*, c.name AS collection_name
      FROM stamps s
      LEFT JOIN collections c ON c.id = s.collection_id
      $whereSql
      ORDER BY s.created_at DESC
      ''',
      args,
    );

    return rows.map(StampItemModel.fromMap).toList(growable: false);
  }

  Future<List<CollectionSummary>> getCollectionSummaries() async {
    final Database db = await _appDatabase.database;

    // Get collections with stamp counts.
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
      SELECT c.id, c.name, COUNT(s.id) AS stamp_count
      FROM collections c
      LEFT JOIN stamps s ON s.collection_id = c.id
      GROUP BY c.id, c.name
      ORDER BY c.name COLLATE NOCASE ASC
      ''',
    );

    final List<CollectionSummary> summaries = <CollectionSummary>[];
    for (final row in rows) {
      final int id = row['id'] as int;
      final String name = row['name'] as String;
      final int count = row['stamp_count'] as int;

      // Get up to 3 preview image paths for this collection.
      final List<Map<String, Object?>> previewRows = await db.rawQuery(
        '''
        SELECT image_path FROM stamps
        WHERE collection_id = ? AND image_path IS NOT NULL AND image_path <> ''
        ORDER BY created_at DESC
        LIMIT 3
        ''',
        [id],
      );
      final List<String> previews = previewRows
          .map((r) => r['image_path'] as String)
          .toList(growable: false);

      summaries.add(CollectionSummary(
        id: id,
        name: name,
        stampCount: count,
        previewPaths: previews,
      ));
    }

    return summaries;
  }

  Future<List<CaptureCollectionRecord>> getCollections() async {
    final Database db = await _appDatabase.database;
    final List<Map<String, Object?>> rows = await db.query(
      'collections',
      columns: <String>['id', 'name'],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows
        .map(
          (row) => CaptureCollectionRecord(
            id: row['id'] as int,
            name: row['name'] as String,
          ),
        )
        .toList(growable: false);
  }

  Future<int> createCollection(String name) async {
    final Database db = await _appDatabase.database;
    final int now = DateTime.now().millisecondsSinceEpoch;
    return db.insert('collections', <String, Object?>{
      'collector_id': 1,
      'name': name.trim(),
      'current_value': 0,
      'created_at': now,
    });
  }

  Future<List<String>> getCategories() async {
    final Database db = await _appDatabase.database;
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
      SELECT DISTINCT category
      FROM stamps
      WHERE category IS NOT NULL AND category <> ''
      ORDER BY category COLLATE NOCASE ASC
      ''',
    );
    return rows
        .map((row) => (row['category'] as String).trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
  }
}

class CaptureCollectionRecord {
  const CaptureCollectionRecord({required this.id, required this.name});

  final int id;
  final String name;
}
