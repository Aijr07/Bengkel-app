// lib/history_provider.dart
import 'package:flutter/material.dart';
import 'service_history_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryProvider extends ChangeNotifier {
  List<ServiceHistoryModel> _historyList = [];
  List<ServiceHistoryModel> get historyList => _historyList;

  Future<void> loadHistoryFromDatabase() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('service_history');

    _historyList = maps.map((map) {
      return ServiceHistoryModel(
        id: map['id'],
        date: map['date'],
        services: (map['services'] as String).split(','),
        totalPrice: map['totalPrice'],
        details: map['details'],
      );
    }).toList();

    notifyListeners();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'service_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE service_history(id TEXT PRIMARY KEY, date TEXT, services TEXT, totalPrice INTEGER, details TEXT)',
        );
      },
    );
  }

  Future<void> addHistory(ServiceHistoryModel history) async {
    final db = await _initDatabase();
    await db.insert(
      'service_history',
      {
        'id': history.id,
        'date': history.date,
        'services': history.services.join(','),
        'totalPrice': history.totalPrice,
        'details': history.details,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _historyList.insert(0, history);
    notifyListeners();
  }
}