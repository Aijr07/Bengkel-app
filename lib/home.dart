import 'package:flutter/material.dart';
import 'package:flutter_application_1/Aboutus.dart';
import 'package:flutter_application_1/BookingService.dart';
import 'package:flutter_application_1/RiwayatService.dart';
import 'package:flutter_application_1/Profil.dart';
import 'package:flutter_application_1/Setting.dart';
import 'package:flutter_application_1/Status.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userName = "";  // Untuk menyimpan nama pengguna

  @override
  void initState() {
    super.initState();
    _getUserInfo();  // Ambil info pengguna saat halaman pertama kali dibuat
  }

  // Ambil informasi pengguna yang sedang login
  void _getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Ambil fullName berdasarkan uid
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['fullName']; // Mengambil fullName dari Firestore
        });
      } else {
        setState(() {
          _userName = user.email ?? 'Pengguna'; // Menampilkan email jika tidak ditemukan fullName
        });
      }
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() => _selectedIndex = index);
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Pencarian...",
        hintStyle: TextStyle(color: Colors.blueGrey[300]),
        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildServiceButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Replaces primary
        foregroundColor: Colors.white, // Replaces onPrimary
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ), // Adjusted padding for the button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the icon and text
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16), // Space between icon and text
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "AyamGarage",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          // Menampilkan nama pengguna yang login di kanan atas
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 14, backgroundColor: Color(0xFFD9D9D9)),
                  SizedBox(width: 8),
                  Text(
                    _userName,  // Menampilkan nama pengguna yang login
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        children: [
          const Text(
            'Selamat Datang!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildServiceButton(
            icon: Icons.build,
            text: "Booking service",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingPage()),
            ),
          ),
          const SizedBox(height: 15),
          _buildServiceButton(
            icon: Icons.history,
            text: "Riwayat Service",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            ),
          ),
          const SizedBox(height: 15),
          _buildServiceButton(
            icon: Icons.sync,
            text: "Status Service",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatusServicePage(),
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildServiceButton(
            icon: Icons.info_outline,
            text: "About us",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsPage()),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 0, 94, 255),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
