// lib/history_provider.dart

import 'package:flutter/material.dart';
import 'service_history_model.dart'; // Impor model yang baru kita buat

class HistoryProvider with ChangeNotifier {
  // Variabel ini (_historyList) akan menyimpan semua data riwayat servis.
  // Tanda underscore (_) di awal nama berarti variabel ini bersifat pribadi (private).
  final List<ServiceHistoryModel> _historyList = [];

  // 'Getter' ini digunakan agar halaman lain bisa membaca daftar riwayat
  // tanpa bisa mengubahnya secara langsung.
  List<ServiceHistoryModel> get historyList => _historyList;

  // Fungsi ini yang akan kita panggil dari halaman booking untuk menambahkan
  // data riwayat baru ke dalam _historyList.
  void addHistory(ServiceHistoryModel newHistory) {
    _historyList.insert(0, newHistory); // insert(0, ..) agar data baru selalu di paling atas

    // Perintah ini sangat penting! Ia akan memberitahu semua widget yang 'mendengarkan'
    // bahwa ada perubahan data, sehingga mereka bisa memperbarui tampilannya.
    notifyListeners();
  }
}