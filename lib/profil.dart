import 'package:flutter/material.dart';
import 'package:flutter_application_1/Login.dart'; // Sesuaikan dengan path halaman login Anda

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ganti background menjadi putih
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Warna biru untuk AppBar
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          // Bagian Header Profil
          Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'https://placehold.co/100x100/FFFFFF/000000?text=User'), // Ganti dengan URL gambar pengguna
              ),
              const SizedBox(height: 16),
              const Text(
                'Ahmad Syahid', // Ganti dengan nama pengguna
                style: TextStyle(
                  color: Colors.black, // Ganti warna teks menjadi hitam
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'ahmad.syahid@example.com', // Ganti dengan email pengguna
                style: TextStyle(
                  color: Colors.grey, // Warna teks email tetap abu-abu
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Menu Pilihan
          _buildProfileMenuItem(
            icon: Icons.person_outline,
            text: 'Edit Profil',
            onTap: () {
              // Navigasi ke halaman edit profil
              print('Edit Profil tapped');
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.lock_outline,
            text: 'Ganti Password',
            onTap: () {
              // Navigasi ke halaman ganti password
              print('Ganti Password tapped');
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.notifications_none_outlined,
            text: 'Notifikasi',
            onTap: () {
              // Navigasi ke halaman pengaturan notifikasi
              print('Notifikasi tapped');
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.privacy_tip_outlined,
            text: 'Kebijakan Privasi',
            onTap: () {
              // Navigasi ke halaman kebijakan privasi
              print('Kebijakan Privasi tapped');
            },
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.blueAccent), // Divider berwarna biru
          const SizedBox(height: 10),

          // Tombol Logout
          _buildProfileMenuItem(
            icon: Icons.logout,
            text: 'Logout',
            textColor: Colors.red, // Warna khusus untuk logout
            onTap: () {
              // Tampilkan dialog konfirmasi sebelum logout
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  title: const Text('Konfirmasi Logout', style: TextStyle(color: Colors.white)),
                  content: const Text('Apakah Anda yakin ingin keluar?', style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Tutup dialog
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Kembali ke halaman login dan hapus semua halaman sebelumnya
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat setiap item menu
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black, // Ganti warna teks menjadi hitam
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor,
        size: 24,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: textColor, // Warna teks disesuaikan
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
