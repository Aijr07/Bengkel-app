import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        title: const Text(
          'Tentang Kami',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dibangun oleh KLP 5 ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF2C2C2C)),
                  const SizedBox(height: 16),
                  const Text(
                    'Aplikasi diciptakan oleh kelompok 5 yang dimana beranggotakan Ahmad Syahid, Muhammad Fikri Maulana, Fadiyah Sri Mutiyah, Khadijah Kurniawati Wahid, Azzahra Hasan, dan Ardiansyah Ronny, dibuat dengan tujuan memenuhi tugas final mobile.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Aplikasi ini kami ciptakan agar membantu memudahkan orang-orang yang akan melakukan service motor agar bisa melakukan pemesanan service motor dari rumah.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- MULAI PENAMBAHAN ---
                  const Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactInfo(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'MuhammadFikri123.com',
                    onTap: () {
                      // Logika untuk membuka aplikasi email
                      print('Email tapped');
                    },
                  ),
                  _buildContactInfo(
                    icon: Icons.phone_outlined,
                    title: 'WhatsApp',
                    subtitle: '+62 812 3456 7890',
                    onTap: () {
                      // Logika untuk membuka WhatsApp
                      print('WhatsApp tapped');
                    },
                  ),
                  _buildContactInfo(
                    // Anda bisa mengganti ini dengan ikon Instagram jika punya
                    icon: Icons.group_work_outlined,
                    title: 'Instagram',
                    subtitle: '@muhammadfikri.official',
                    onTap: () {
                      // Logika untuk membuka Instagram
                      print('Instagram tapped');
                    },
                  ),
                  // --- SELESAI PENAMBAHAN ---

                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Terima kasih telah menjadi bagian dari perjalanan kami.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat item kontak
  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Icon(icon, color: Colors.white70, size: 28),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      onTap: onTap,
    );
  }
}
