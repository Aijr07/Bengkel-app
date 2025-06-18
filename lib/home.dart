import 'package:flutter/material.dart';
import 'package:flutter_application_1/booking_service.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/riwayat_service.dart';
import 'package:flutter_application_1/profil.dart';

// Mengubah nama kelas menjadi HomePage sesuai konvensi Dart/Flutter
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 1; // Dimulai dari index 1 (item tengah)

  void _onItemTapped(int index) {
    // Logika untuk navigasi saat item di-tap
    if (index == 2) {
      // Index 2 adalah Profile, arahkan kembali ke halaman Login (sebagai logout)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const login(),
        ), // Gunakan nama kelas LoginPage
        (Route<dynamic> route) => false,
      );
    } else {
      // Untuk item lain, perbarui state untuk mengubah tampilan
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background sangat gelap
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.settings_suggest, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              "AyamGarage",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: Color(0xFFD9D9D9)),
                SizedBox(width: 8),
                Text(
                  "Ahmad Syahid",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, left: 24.0, bottom: 16.0),
            child: Text(
              'Halaman Utama',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E), // Warna area konten
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildServiceButton(
                    context,
                    icon: Icons.build,
                    text: "Booking service",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingPage(),
                        ),
                      );
                    }, // Ganti dengan navigasi
                  ),
                  const SizedBox(height: 15),
                  _buildServiceButton(
                    context,
                    icon: Icons.history,
                    text: "Riwayat Service",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      );
                    }, // Ganti dengan navigasi
                  ),
                  const SizedBox(height: 15),
                  _buildServiceButton(
                    context,
                    icon: Icons.sync,
                    text: "Status Service",
                    onPressed: () => print("Status service tapped"),
                  ),
                  const SizedBox(height: 15),
                  _buildServiceButton(
                    context,
                    icon: Icons.info_outline,
                    text: "About us",
                    onPressed: () => print("About us tapped"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedIndex == 1 ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.settings,
                size: 30,
                color: _selectedIndex == 1 ? Colors.black : Colors.white,
              ),
            ),
            label: 'Settings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Search bar dengan tema gelap
  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Pencarian",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Tombol menu dengan tema gelap
  Widget _buildServiceButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83), // Warna tombol
        foregroundColor: Colors.white, // Warna teks & ikon
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
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
}
