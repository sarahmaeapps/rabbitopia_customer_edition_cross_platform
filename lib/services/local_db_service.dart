import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/housing.dart';
import '../models/feed_entry.dart';
import '../models/medical_care.dart';

class LocalDbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rabbitopia_local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE housing (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hutchId TEXT,
        residents TEXT,
        predatorSigns TEXT,
        upgrades TEXT,
        repairHistory TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE feed_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT,
        supplier TEXT,
        weightLbs REAL,
        price REAL,
        date TEXT,
        protein REAL,
        fiber REAL,
        fat REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE medical_care (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rabbitId TEXT,
        date TEXT,
        description TEXT,
        cost REAL,
        medications TEXT,
        vetNotes TEXT
      )
    ''');
  }

  // --- Housing ---
  Future<int> insertHousing(Housing housing) async {
    final db = await database;
    return await db.insert('housing', housing.toMap());
  }

  Future<List<Housing>> getAllHousing() async {
    final db = await database;
    final result = await db.query('housing', orderBy: 'hutchId ASC');
    return result.map((json) => Housing.fromMap(json)).toList();
  }

  // --- Feed ---
  Future<int> insertFeedEntry(FeedEntry entry) async {
    final db = await database;
    return await db.insert('feed_entries', entry.toMap());
  }

  Future<List<FeedEntry>> getAllFeedEntries() async {
    final db = await database;
    final result = await db.query('feed_entries', orderBy: 'date DESC');
    return result.map((json) => FeedEntry.fromMap(json)).toList();
  }

  // --- Medical ---
  Future<int> insertMedicalCare(MedicalCare care) async {
    final db = await database;
    return await db.insert('medical_care', care.toMap());
  }

  Future<List<MedicalCare>> getMedicalCareForRabbit(String rabbitId) async {
    final db = await database;
    final result = await db.query('medical_care', where: 'rabbitId = ?', whereArgs: [rabbitId]);
    return result.map((json) => MedicalCare.fromMap(json)).toList();
  }

  Future<List<MedicalCare>> getAllMedicalCare() async {
    final db = await database;
    final result = await db.query('medical_care', orderBy: 'date DESC');
    return result.map((json) => MedicalCare.fromMap(json)).toList();
  }
}
