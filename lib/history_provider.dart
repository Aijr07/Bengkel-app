import 'package:flutter/material.dart';
import 'service_history_model.dart';

class HistoryProvider with ChangeNotifier {
  List<ServiceHistoryModel> historyList = [];

  // Mengambil riwayat dari database atau sumber data lain
  Future<void> loadHistoryFromDatabase() async {
    // Ambil data dari database dan simpan dalam historyList
    // Panggil notifyListeners() setelah data diambil
    notifyListeners();
  }

  // Mendapatkan riwayat servis berdasarkan ID
  ServiceHistoryModel? getHistoryById(String historyId) {
  try {
    return historyList.firstWhere(
      (history) => history.id == historyId,
    );
  } catch (e) {
    // Menangani jika data tidak ditemukan
    return null;
  }
}


  // Menyimpan riwayat servis ke database
  Future<void> saveHistoryForUser(String userId, ServiceHistoryModel history) async {
    // Simpan data riwayat servis untuk pengguna
    notifyListeners();
  }

  // Update status riwayat servis
  Future<void> updateHistoryStatus(String historyId, String newStatus) async {
    final history = getHistoryById(historyId);
    if (history != null) {
      history.status = newStatus;
      // Update status di database atau sumber lain
      notifyListeners();
    }
  }
  void addHistory(ServiceHistoryModel history) {
    historyList.add(history);  // Menambah history baru
    notifyListeners();  // Memberi tahu listener bahwa data telah berubah
  }
}
