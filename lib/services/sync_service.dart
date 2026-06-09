import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/repositories/poultry_repository.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  Database? _db;
  final PoultryRepository _repo = PoultryRepository();

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'poultry_sync.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sync_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bird_type TEXT NOT NULL,
            sheet_type TEXT NOT NULL,
            flock_id TEXT NOT NULL,
            data_json TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'pending_sync',
            retry_count INTEGER DEFAULT 0,
            error_message TEXT,
            created_at_local INTEGER NOT NULL,
            synced_at INTEGER
          )
        ''');
      },
    );
  }

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<int> queueRecord(Map<String, dynamic> recordData) async {
    if (_db == null) return -1;
    final data = Map<String, dynamic>.from(recordData);
    data.remove('id');
    return await _db!.insert('sync_queue', {
      'bird_type': data['birdType'] ?? '',
      'sheet_type': data['sheetType'] ?? '',
      'flock_id': data['flockId'] ?? '',
      'data_json': jsonEncode(data),
      'status': 'pending_sync',
      'retry_count': 0,
      'created_at_local': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingQueue() async {
    if (_db == null) return [];
    return await _db!.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['pending_sync'],
      orderBy: 'created_at_local ASC',
    );
  }

  Future<void> syncPendingRecords() async {
    if (!await isOnline()) return;
    final pending = await getPendingQueue();
    for (final item in pending) {
      try {
        final data = jsonDecode(item['data_json']);
        final sheetType = item['sheet_type'];
        await _repo.addRecord(sheetType, Map<String, dynamic>.from(data));
        await _db!.update(
          'sync_queue',
          {
            'status': 'synced',
            'synced_at': DateTime.now().millisecondsSinceEpoch,
          },
          where: 'id = ?',
          whereArgs: [item['id']],
        );
      } catch (e) {
        final retries = (item['retry_count'] as int) + 1;
        await _db!.update(
          'sync_queue',
          {
            'status': retries >= 3 ? 'sync_failed' : 'pending_sync',
            'retry_count': retries,
            'error_message': e.toString(),
          },
          where: 'id = ?',
          whereArgs: [item['id']],
        );
      }
    }
  }

  Future<int> getPendingCount() async {
    if (_db == null) return 0;
    final result = await _db!.rawQuery(
      "SELECT COUNT(*) as count FROM sync_queue WHERE status = 'pending_sync'"
    );
    return result.first['count'] as int? ?? 0;
  }
}
