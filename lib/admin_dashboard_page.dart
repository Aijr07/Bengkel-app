// lib/admin_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Ubah menjadi StatefulWidget karena kita akan mengelola data
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  // Fungsi untuk logout
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  // Fungsi untuk mengubah status di Firestore
  Future<void> _updateStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('service_orders').doc(docId).update({
        'status': newStatus,
      });
      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status berhasil diubah menjadi $newStatus')),
      );
    } catch (e) {
      // Tampilkan notifikasi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Kelola Pesanan Servis'),
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      // Gunakan StreamBuilder untuk mendapatkan data real-time dari Firestore
      body: StreamBuilder<QuerySnapshot>(
        // 'stream' memberitahu widget untuk mendengarkan perubahan pada koleksi 'service_orders'
        stream: FirebaseFirestore.instance.collection('service_orders').snapshots(),
        // 'builder' akan membangun ulang UI setiap kali ada data baru
        builder: (context, snapshot) {
          // Tampilkan loading indicator jika sedang memuat data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Tampilkan pesan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }
          // Tampilkan pesan jika tidak ada data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada pesanan servis.', style: TextStyle(color: Colors.grey)));
          }

          // Jika ada data, bangun daftar pesanan
          final serviceDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: serviceDocs.length,
            itemBuilder: (context, index) {
              final doc = serviceDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              // Ambil data dari dokumen
              final String customerName = data['customerName'] ?? 'Tanpa Nama';
              final String currentStatus = data['status'] ?? 'N/A';
              final List<dynamic> services = data['services'] ?? [];

              // Opsi status yang bisa dipilih
              final List<String> statusOptions = ['Pesanan Diterima', 'Dalam Antrian', 'Sedang Dikerjakan', 'Selesai'];

              return Card(
                color: const Color.fromARGB(255, 42, 76, 83),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pelanggan: $customerName',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Layanan: ${services.join(', ')}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status:', style: TextStyle(color: Colors.white, fontSize: 16)),
                          // Dropdown untuk mengubah status
                          DropdownButton<String>(
                            value: currentStatus,
                            dropdownColor: const Color.fromARGB(255, 42, 76, 83),
                            style: const TextStyle(color: Colors.white),
                            items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                // Panggil fungsi update saat status baru dipilih
                                _updateStatus(doc.id, newValue);
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
          );
        },
      ),
    );
  }
}