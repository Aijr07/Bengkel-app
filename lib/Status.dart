import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/booking_database.dart';

enum StepStatus { completed, inProgress, pending }

class StatusServicePage extends StatefulWidget {
  const StatusServicePage({super.key});

  @override
  State<StatusServicePage> createState() => _StatusServicePageState();
}

class _StatusServicePageState extends State<StatusServicePage> {
  late Future<String?> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = _fetchLatestStatus();
  }

  Future<String?> _fetchLatestStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await BookingDatabase.instance.getLatestStatusByUserId(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _statusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white, // Ganti background menjadi putih
            appBar: AppBar(
              backgroundColor: Colors.blueAccent, // Warna biru untuk AppBar
              title: const Text('Status Servis Anda', style: TextStyle(color: Colors.white)),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white, // Ganti background menjadi putih
            appBar: AppBar(
              backgroundColor: Colors.blueAccent, // Warna biru untuk AppBar
              title: const Text('Status Servis Anda', style: TextStyle(color: Colors.white)),
            ),
            body: Center(child: Text('Terjadi error: ${snapshot.error}', style: const TextStyle(color: Colors.black))),
          );
        }

        final currentStatus = snapshot.data ?? 'Pesanan Diterima';

        return Scaffold(
          backgroundColor: Colors.white, // Ganti background menjadi putih
          appBar: AppBar(
            backgroundColor: Colors.blueAccent, // Warna biru untuk AppBar
            title: const Text('Status Servis Anda', style: TextStyle(color: Colors.white)),
          ),
          body: _buildStatusTimeline(currentStatus),
        );
      },
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final statusList = ['Pesanan Diterima', 'Dalam Antrian', 'Sedang Dikerjakan', 'Selesai'];
    final statusIndex = statusList.indexOf(currentStatus);

    final List<Map<String, dynamic>> serviceSteps = [
      {'title': 'Pesanan Diterima', 'subtitle': 'Pesanan Anda telah dikonfirmasi.', 'icon': Icons.receipt_long},
      {'title': 'Dalam Antrian', 'subtitle': 'Motor Anda sedang menunggu giliran.', 'icon': Icons.queue},
      {'title': 'Sedang Dikerjakan', 'subtitle': 'Mekanik kami sedang bekerja.', 'icon': Icons.build},
      {'title': 'Selesai', 'subtitle': 'Servis telah selesai, siap diambil.', 'icon': Icons.check_circle},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: serviceSteps.length,
      itemBuilder: (context, index) {
        final step = serviceSteps[index];
        StepStatus stepStatus;
        if (index < statusIndex) {
          stepStatus = StepStatus.completed;
        } else if (index == statusIndex) {
          stepStatus = StepStatus.inProgress;
        } else {
          stepStatus = StepStatus.pending;
        }

        return _buildStatusStep(
          title: step['title'],
          subtitle: step['subtitle'],
          icon: step['icon'],
          status: stepStatus,
          isLastStep: index == serviceSteps.length - 1,
        );
      },
    );
  }

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
        iconColor = Colors.blueAccent; // Ganti warna icon menjadi biru
        textColor = Colors.black; // Teks warna hitam untuk status selesai
        break;
      case StepStatus.inProgress:
        iconColor = Colors.orange; // Ganti warna icon untuk status sedang dikerjakan
        textColor = Colors.black; // Teks warna hitam untuk status sedang dikerjakan
        break;
      case StepStatus.pending:
        iconColor = Colors.grey; // Ganti warna icon untuk status pending
        textColor = Colors.grey; // Teks warna abu-abu untuk status pending
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor.withOpacity(0.2)),
                child: Icon(icon, color: iconColor),
              ),
              if (!isLastStep)
                Expanded(child: Container(width: 2, color: iconColor.withOpacity(0.3))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14)),
                if (!isLastStep) const SizedBox(height: 48),
              ],
            ),
          )
        ],
      ),
    );
  }
}
