import 'package:flutter/material.dart';
import 'package:flutter_application_1/Aboutus.dart';
import 'package:flutter_application_1/BookingService.dart';
import 'package:flutter_application_1/RiwayatService.dart';
import 'package:flutter_application_1/Profil.dart';
import 'package:flutter_application_1/Setting.dart';
import 'package:flutter_application_1/Status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- DATA CONTOH UNTUK LIST PROMO ---
  // Data ini tetap ada untuk bagian bawah halaman
  final List<Map<String, String>> _promoData = [
    {
      "title": "Promo Ganti Oli Hemat!",
      "subtitle": "Diskon 20% untuk semua jenis oli. Klik untuk info!",
      "icon": "promo"
    },
    {
      "title": "Tips Merawat Aki Kendaraan",
      "subtitle": "Jaga aki tetap awet dengan 5 langkah mudah ini.",
      "icon": "tips"
    },
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Navigasi Bottom Bar tidak berubah
    switch (index) {
      case 0:
        setState(() => _selectedIndex = index);
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }

  // --- FUNGSI-FUNGSI DARI KODE LAMA ANDA DIKEMBALIKAN ---
  // Kita kembalikan semua fungsi helper Anda agar fitur tidak hilang.

  // 1. Fungsi untuk Search Bar
  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white), // Sesuaikan warna teks input
      decoration: InputDecoration(
        hintText: "Pencarian...",
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color.fromARGB(255, 42, 76, 83), // Warna field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // 2. Fungsi untuk Tombol Service Utama
  Widget _buildServiceButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  // 3. Fungsi untuk membuat Card Promo (dipisahkan agar rapi)
  Widget _buildPromoCard(Map<String, String> promo) {
     return Card(
        color: const Color.fromARGB(255, 42, 76, 83),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(promo['icon'] == 'promo' ? Icons.local_offer : Icons.lightbulb_outline, color: Colors.white, size: 32),
          title: Text(promo['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(promo['subtitle']!, style: const TextStyle(color: Colors.white70)),
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Info: ${promo['title']!}')),
             );
          },
        ),
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        // AppBar Anda tidak berubah
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.settings_suggest, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text("AyamGarage", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
            onPressed: () {},
          ),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 14, backgroundColor: Color(0xFFD9D9D9)),
                  SizedBox(width: 8),
                  Text("Ahmad Syahid", style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
      // --- PERUBAHAN UTAMA: Menggunakan ListView untuk menggabungkan semua widget ---
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        children: [
          // 1. Judul Halaman
          const Text(
            'Selamat Datang, Ahmad!',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 2. Search Bar dikembalikan
          _buildSearchBar(),
          const SizedBox(height: 24),
          
          // 3. Semua Tombol Utama Anda dikembalikan
          _buildServiceButton(
            icon: Icons.build,
            text: "Booking service",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage())),
          ),
          const SizedBox(height: 15),
          _buildServiceButton(
            icon: Icons.history,
            text: "Riwayat Service",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage())),
          ),
          const SizedBox(height: 15),
          _buildServiceButton(
            icon: Icons.sync,
            text: "Status Service",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StatusServicePage())),
          ),
          const SizedBox(height: 15),
          _buildServiceButton(
            icon: Icons.info_outline,
            text: "About us",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage())),
          ),
          const SizedBox(height: 24),
          
          // 4. Judul untuk bagian daftar promo
          const Text(
            'Promo & Berita',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // 5. Daftar Promo & Berita
          // Kita menggunakan .map untuk mengubah setiap item data menjadi Widget Card,
          // lalu '...' (spread operator) untuk memasukkan hasilnya ke dalam ListView.
          ..._promoData.map((promo) => _buildPromoCard(promo)).toList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBar Anda tidak berubah
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(color: _selectedIndex == 0 ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(20)),
              child: Icon(Icons.home, size: 30, color: _selectedIndex == 0 ? Colors.black : Colors.white),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.settings, size: 30), label: 'Settings'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 30), label: 'Profile'),
        ],
      ),
    );
  }
}