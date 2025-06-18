import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background sangat gelap
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'Halaman Riwayat Servis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          // Contoh card riwayat servis
          _buildHistoryCard(
            serviceTitle: 'Ganti Oli',
            date: '15 Juni 2025',
            onRatePressed: () => print('Nilai Ganti Oli'),
            onDetailPressed: () => print('Detail Ganti Oli'),
          ),
          const SizedBox(height: 16),
          _buildHistoryCard(
            serviceTitle: 'Servis Ringan',
            date: '25 Juni 2025',
            onRatePressed: () => print('Nilai Servis Ringan'),
            onDetailPressed: () => print('Detail Servis Ringan'),
          ),
          const SizedBox(height: 16),
          _buildHistoryCard(
            serviceTitle: 'Servis Berat',
            date: '18 November 2025',
            onRatePressed: () => print('Nilai Servis Berat'),
            onDetailPressed: () => print('Detail Servis Berat'),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat setiap card riwayat
  Widget _buildHistoryCard({
    required String serviceTitle,
    required String date,
    required VoidCallback onRatePressed,
    required VoidCallback onDetailPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 42, 76, 83), // Warna card
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris untuk judul dan tombol detail
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Judul Servis
              Text(
                serviceTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Tombol Detail
              ElevatedButton(
                onPressed: onDetailPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 245, 245, 245), // Warna hijau
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('Detail'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Tanggal Servis
          Text(
            'Waktu: $date',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          
          // Tombol Nilai
          ElevatedButton(
            onPressed: onRatePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              minimumSize: const Size(0, 30),
            ),
            child: const Text('Nilai', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
