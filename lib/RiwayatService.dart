import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'history_provider.dart';
import 'service_history_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        title: const Text('Halaman Riwayat Servis',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: historyProvider.loadHistoryFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyList = historyProvider.historyList;

          return historyList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada riwayat servis.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final historyItem = historyList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildHistoryCard(
                        context: context,
                        history: historyItem,
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required ServiceHistoryModel history,
  }) {
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
            children: [
              Expanded(
                child: Text(
                  servicesText,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                onPressed: () => _showDetailDialog(context, history),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Detail'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Waktu: ${history.date}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text('Total: ${currencyFormatter.format(history.totalPrice)}',
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, ServiceHistoryModel history) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Detail Riwayat Servis', style: TextStyle(color: Colors.white)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tanggal: ${history.date}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            const Text('Layanan yang Dipesan:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ...history.services.map((s) => Text('• $s', style: const TextStyle(color: Colors.white70))),
            if (history.details != null && history.details!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Catatan Tambahan:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(history.details!, style: const TextStyle(color: Colors.white70)),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Harga:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(currencyFormatter.format(history.totalPrice),
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              ],
            )
          ],
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
