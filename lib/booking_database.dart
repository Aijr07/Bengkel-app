import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookingDatabase {
  static final BookingDatabase instance = BookingDatabase._init();
  static Database? _database;

  BookingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bookings.db');
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
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId TEXT,
        customerName TEXT,
        orderDate TEXT,
        services TEXT,
        totalPrice INTEGER,
        details TEXT,
        status TEXT,
        createdAt TEXT
      )
    ''');
  }

  /// Menyimpan booking baru ke tabel bookings
  Future<int> insertBooking(Map<String, dynamic> bookingData) async {
    final db = await instance.database;
    return await db.insert('bookings', bookingData);
  }

  /// Mendapatkan semua data booking
  Future<List<Map<String, dynamic>>> getAllBookings() async {
    final db = await instance.database;
    return await db.query('bookings', orderBy: 'id DESC');
  }

  /// Mendapatkan total pemasukan dari pesanan yang statusnya 'Selesai'
  Future<double> getTotalIncome() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT SUM(totalPrice) as total FROM bookings WHERE status = 'Selesai'"
    );
    return result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }
  // booking_database.dart (tambahkan method ini)
  Future<String?> getLatestStatusByUserId(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'bookings',
      where: 'customerId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['status'] as String?;
    } else {
      return null;
    }
  }

  Future<bool> hasActiveBooking(String userId) async {
  final db = await instance.database;
  final result = await db.query(
    'bookings',
    where: 'customerId = ? AND status != ?',
    whereArgs: [userId, 'Selesai'],
    orderBy: 'createdAt DESC',
    limit: 1,
  );

  return result.isNotEmpty;
}


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
