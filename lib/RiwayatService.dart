// lib/RiwayatService.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';  // <-- IMPORT PROVIDER
import 'history_provider.dart';        // <-- IMPORT HISTORY PROVIDER
import 'service_history_model.dart';   // <-- IMPORT MODEL DATA

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PERUBAHAN UTAMA DIMULAI DI SINI ---
    // Kita gunakan widget 'Consumer' untuk 'mendengarkan' perubahan dari HistoryProvider.
    // Setiap kali ada data baru ditambahkan, 'builder' ini akan otomatis dijalankan ulang.
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        // Ambil daftar riwayat dari provider
        final historyList = historyProvider.historyList;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 42, 76, 83),
            elevation: 0,
            title: const Text('Halaman Riwayat Servis', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          // Cek apakah daftar riwayat kosong
          body: historyList.isEmpty
              // Jika kosong, tampilkan pesan di tengah layar
              ? const Center(
                  child: Text(
                    'Belum ada riwayat servis.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              // Jika ada data, bangun daftar menggunakan ListView.builder
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    // Ambil satu item riwayat berdasarkan posisinya (index)
                    final historyItem = historyList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      // Panggil widget card dengan data dari historyItem
                      child: _buildHistoryCard(
                        context: context,
                        history: historyItem,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Widget card sekarang menerima satu objek ServiceHistoryModel, bukan banyak string
  Widget _buildHistoryCard({
    required BuildContext context,
    required ServiceHistoryModel history,
  }) {
    // Gabungkan daftar layanan menjadi satu teks yang mudah dibaca
    final servicesText = history.services.join(', ');
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 42, 76, 83),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Servis (diperluas agar tidak overflow jika teks panjang)
              Expanded(
                child: Text(
                  servicesText,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              // Tombol Detail
              ElevatedButton(
                onPressed: () => _showDetailDialog(context, history),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('Detail'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tanggal Servis
          Text(
            'Waktu: ${history.date}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
           const SizedBox(height: 4),
          // Tampilkan Total Harga
           Text(
            'Total: ${currencyFormatter.format(history.totalPrice)}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          // Tombol Nilai (fungsionalitas bisa dikembangkan nanti)
          ElevatedButton(
            onPressed: () { /* Logika untuk memberi nilai */ },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              minimumSize: const Size(0, 30),
            ),
            child: const Text('Nilai', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // Fungsi baru untuk menampilkan dialog yang lebih detail
  void _showDetailDialog(BuildContext context, ServiceHistoryModel history) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Detail Riwayat Servis', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tanggal: ${history.date}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              const Text('Layanan yang Dipesan:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              // Tampilkan semua layanan sebagai daftar
              ...history.services.map((service) => Text('• $service', style: const TextStyle(color: Colors.white70))),
              
              // Tampilkan catatan jika ada
              if (history.details != null && history.details!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Catatan Tambahan:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(history.details!, style: const TextStyle(color: Colors.white70)),
              ],
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Harga:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    currencyFormatter.format(history.totalPrice),
                    style: const TextStyle(color: Color(0xFF32CD32), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF32CD32))),
          )
        ],
      ),
    );
  }
}