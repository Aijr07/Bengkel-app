import 'package:flutter/material.dart';

// Mengubah menjadi StatefulWidget untuk mengelola state dari Switch
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Variabel state untuk switch
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        title: const Text(
          'Pengaturan',
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
          _buildSectionHeader('Umum'),
          _buildSwitchTile(
            title: 'Notifikasi',
            subtitle: 'Terima pembaruan dan pengingat',
            icon: Icons.notifications_none_outlined,
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Mode Gelap',
            subtitle: 'Aktifkan untuk tema gelap',
            icon: Icons.dark_mode_outlined,
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSettingsItem(
            title: 'Bahasa',
            subtitle: 'Indonesia',
            icon: Icons.language_outlined,
            onTap: () {
              // Logika untuk mengubah bahasa
              print('Language setting tapped');
            },
          ),
          const Divider(color: Color(0xFF2C2C2C), indent: 70),
          _buildSectionHeader('Akun'),
          _buildSettingsItem(
            title: 'Keamanan',
            subtitle: 'Ganti password, 2FA',
            icon: Icons.security_outlined,
            onTap: () {
              // Navigasi ke halaman keamanan
              print('Security setting tapped');
            },
          ),
          const Divider(color: Color(0xFF2C2C2C), indent: 70),
          _buildSectionHeader('Lainnya'),
          _buildSettingsItem(
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            icon: Icons.info_outline,
            onTap: () {
              // Navigasi ke halaman tentang
              print('About setting tapped');
            },
          ),
        ],
      ),
    );
  }

  // Widget helper untuk header seksi
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Widget helper untuk item menu dengan Switch
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF32CD32),
        inactiveTrackColor: Colors.grey.shade700,
      ),
    );
  }

  // Widget helper untuk item menu biasa
  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}
