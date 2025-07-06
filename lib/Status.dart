// lib/Status.dart (Versi Dinamis)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Enum untuk status tetap kita gunakan
enum StepStatus { completed, inProgress, pending }

class StatusServicePage extends StatefulWidget {
  const StatusServicePage({super.key});

  @override
  State<StatusServicePage> createState() => _StatusServicePageState();
}

class _StatusServicePageState extends State<StatusServicePage> {
  // --- PERUBAHAN UTAMA: Gunakan StreamBuilder untuk data dinamis ---

  @override
  Widget build(BuildContext context) {
    // Dapatkan ID pengguna yang sedang login
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        title: const Text('Status Service Anda', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Cek apakah ada pengguna yang login. Jika tidak, tampilkan pesan.
      body: currentUserId == null
          ? const Center(child: Text("Silakan login untuk melihat status servis.", style: TextStyle(color: Colors.grey)))
          : StreamBuilder<QuerySnapshot>(
              // 'stream' sekarang memiliki query '.where()'
              // Ini hanya akan mengambil dokumen di mana field 'customerId' sama dengan ID pengguna yang sedang login
              stream: FirebaseFirestore.instance
                  .collection('service_orders')
                  .where('customerId', isEqualTo: currentUserId)
                  .orderBy('createdAt', descending: true) // Urutkan agar pesanan terbaru di atas
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Anda belum memiliki pesanan servis aktif.', style: TextStyle(color: Colors.grey)));
                }

                // Ambil dokumen pesanan yang paling baru (karena sudah diurutkan)
                final latestOrderDoc = snapshot.data!.docs.first;
                final latestOrderData = latestOrderDoc.data() as Map<String, dynamic>;

                // Panggil widget utama yang membangun timeline berdasarkan data pesanan terbaru
                return _buildStatusTimeline(latestOrderData);
              },
            ),
    );
  }

  // Widget baru untuk membangun seluruh timeline
  Widget _buildStatusTimeline(Map<String, dynamic> orderData) {
    // Ambil status saat ini dari data
    final String currentStatus = orderData['status'] ?? 'N/A';
    
    // Definisikan semua langkah yang mungkin
    final List<Map<String, dynamic>> serviceSteps = [
      {'title': 'Pesanan Diterima', 'subtitle': 'Pesanan Anda telah dikonfirmasi.', 'icon': Icons.receipt_long},
      {'title': 'Dalam Antrian', 'subtitle': 'Motor Anda sedang menunggu giliran.', 'icon': Icons.queue},
      {'title': 'Sedang Dikerjakan', 'subtitle': 'Mekanik kami sedang bekerja.', 'icon': Icons.build},
      {'title': 'Selesai', 'subtitle': 'Servis telah selesai, siap diambil.', 'icon': Icons.check_circle},
    ];

    // Tentukan status untuk setiap langkah berdasarkan status saat ini
    final statusMapping = {
      'Pesanan Diterima': 0,
      'Dalam Antrian': 1,
      'Sedang Dikerjakan': 2,
      'Selesai': 3,
    };
    int currentStepIndex = statusMapping[currentStatus] ?? -1;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      itemCount: serviceSteps.length,
      itemBuilder: (context, index) {
        final step = serviceSteps[index];
        StepStatus status;

        if (index < currentStepIndex) {
          status = StepStatus.completed; // Langkah-langkah sebelumnya dianggap selesai
        } else if (index == currentStepIndex) {
          status = StepStatus.inProgress; // Langkah saat ini sedang berjalan
        } else {
          status = StepStatus.pending; // Langkah-langkah berikutnya masih menunggu
        }

        return _buildStatusStep(
          title: step['title'],
          subtitle: step['subtitle'],
          icon: step['icon'],
          status: status,
          isLastStep: index == serviceSteps.length - 1,
        );
      },
    );
  }

  // Widget helper untuk membuat setiap langkah (tidak ada perubahan signifikan)
  Widget _buildStatusStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required StepStatus status,
    required bool isLastStep,
  }) {
    Color iconColor;
    Color textColor;

    switch (status) {
      case StepStatus.completed:
        iconColor = const Color(0xFF32CD32); // Hijau
        textColor = Colors.white;
        break;
      case StepStatus.inProgress:
        iconColor = Colors.orange;
        textColor = Colors.white;
        break;
      case StepStatus.pending:
        iconColor = Colors.grey.shade600;
        textColor = Colors.grey.shade600;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor.withOpacity(0.15)),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (!isLastStep)
                Expanded(
                  child: Container(
                    width: 2,
                    color: status == StepStatus.completed ? iconColor : Colors.grey.shade800,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14)),
                if (!isLastStep) const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}