import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'booking_database.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Future<List<Map<String, dynamic>>>? _bookingsFuture;
  double _totalIncome = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    setState(() {
      _bookingsFuture = BookingDatabase.instance.getAllBookings();
    });
    final income = await BookingDatabase.instance.getTotalIncome();
    if (mounted) {
      setState(() {
        _totalIncome = income;
      });
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1976D2), // Biru tua
          title: const Text('Konfirmasi Hapus', style: TextStyle(color: Colors.white)),
          content: const Text('Apakah Anda yakin ingin menghapus pesanan ini secara permanen?', style: TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('HAPUS', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final db = await BookingDatabase.instance.database;
                await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
                if (mounted) {
                  Navigator.of(ctx).pop();
                  _loadBookings();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formattedIncome = currencyFormatter.format(_totalIncome);

    return Scaffold(
      backgroundColor: Colors.white, // White background for the page
      appBar: AppBar(
        title: const Text('Kelola Pesanan Servis'),
        backgroundColor: Colors.blueAccent, // Biru untuk AppBar
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}', style: const TextStyle(color: Colors.black)));
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return const Center(child: Text('Belum ada pesanan servis.', style: TextStyle(color: Colors.grey)));
          }

          return Column(
            children: [
              Card(
                color: Colors.blueAccent, // Biru pada card untuk total pemasukan
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pemasukan: ' ,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formattedIncome,
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final data = bookings[index];
                    final int id = data['id'] as int;
                    final String customerName = data['customerName'] ?? 'Tanpa Nama';
                    final String currentStatus = data['status'] ?? 'N/A';
                    final List<String> services = (data['services'] as String).split(',');
                    final List<String> statusOptions = ['Pesanan Diterima', 'Dalam Antrian', 'Sedang Dikerjakan', 'Selesai'];

                    return Card(
                      color: Colors.blueAccent, // Biru untuk card layanan
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pelanggan: $customerName',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (currentStatus == 'Selesai')
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                                    tooltip: 'Hapus Pesanan',
                                    onPressed: () => _showDeleteConfirmationDialog(id),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Layanan: ${services.join(', ')}', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Status:', style: TextStyle(color: Colors.white, fontSize: 16)),
                                DropdownButton<String>(
                                  value: currentStatus,
                                  dropdownColor: Colors.blueAccent, // Biru pada dropdown
                                  style: const TextStyle(color: Colors.white),
                                  items: statusOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) async {
                                    if (newValue != null) {
                                      final db = await BookingDatabase.instance.database;
                                      await db.update(
                                        'bookings',
                                        {'status': newValue},
                                        where: 'id = ?',
                                        whereArgs: [id],
                                      );
                                      _loadBookings(); // reload data dan income
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
