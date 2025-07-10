import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Ganti background menjadi putih
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,  // Warna biru untuk AppBar
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dibangun oleh KLP 5',
                style: TextStyle(
                  color: Colors.black,  // Ubah warna teks menjadi hitam
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFB0BEC5)),  // Ganti warna divider menjadi abu-abu terang
              const SizedBox(height: 16),
              const Text(
                'Aplikasi diciptakan oleh kelompok 5 yang beranggotakan Ahmad Syahid, Muhammad Fikri Maulana, Fadiyah Sri Mutiyah, Khadijah Kurniawati Wahid, Azzahra Hasan, dan Ardiansyah Ronny, dibuat untuk memenuhi tugas final mobile.',
                style: TextStyle(
                  color: Colors.black54,  // Ubah warna teks menjadi abu-abu untuk deskripsi
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Aplikasi ini kami ciptakan agar memudahkan orang-orang yang ingin melakukan servis motor agar bisa melakukan pemesanan dari rumah.',
                style: TextStyle(
                  color: Colors.black54,  // Ubah warna teks menjadi abu-abu untuk deskripsi
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Hubungi Kami',
                style: TextStyle(
                  color: Colors.black,  // Ubah warna teks menjadi hitam
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
                  print('Email tapped');
                },
              ),
              _buildContactInfo(
                icon: Icons.phone_outlined,
                title: 'WhatsApp',
                subtitle: '+62 812 3456 7890',
                onTap: () {
                  print('WhatsApp tapped');
                },
              ),
              _buildContactInfo(
                icon: Icons.group_work_outlined,
                title: 'Instagram',
                subtitle: '@muhammadfikri.official',
                onTap: () {
                  print('Instagram tapped');
                },
              ),
              const SizedBox(height: 32),

              const Text(
                'Galeri Tim Kami',
                style: TextStyle(
                  color: Colors.black,  // Ubah warna teks menjadi hitam
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildImage('assets/images/bengkel1.jpg'),
                  _buildImage('assets/images/bengkel2.jpg'),
                  _buildImage('assets/images/bengkel3.jpg'),
                  _buildImage('assets/images/bengkel4.jpg'),
                ],
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Terima kasih telah menjadi bagian dari perjalanan kami.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,  // Ubah warna teks menjadi abu-abu gelap
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk informasi kontak
  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Icon(icon, color: Colors.blueAccent, size: 28),  // Ganti warna ikon menjadi biru
      title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16)),  // Ubah warna teks menjadi hitam
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      onTap: onTap,
    );
  }

  // Widget helper untuk gambar tim
  static Widget _buildImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
      ),
    );
  }
}
