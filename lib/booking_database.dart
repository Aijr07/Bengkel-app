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

  Future<void> insertBooking(Map<String, dynamic> booking) async {
    final db = await instance.database;
    await db.insert('bookings', booking);
  }

    Future<List<Map<String, dynamic>>> getAllBookings() async {
    final db = await instance.database;
    return await db.query(
      'bookings',
      orderBy: 'createdAt DESC',
    );
  }
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
