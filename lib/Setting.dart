import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Ganti background menjadi putih
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,  // Ganti warna AppBar menjadi biru
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
              print('Language setting tapped');
            },
          ),
          const Divider(color: Color(0xFFE0E0E0), indent: 70),
          _buildSectionHeader('Akun'),
          _buildSettingsItem(
            title: 'Keamanan',
            subtitle: 'Ganti password, 2FA',
            icon: Icons.security_outlined,
            onTap: () {
              print('Security setting tapped');
            },
          ),
          const Divider(color: Color(0xFFE0E0E0), indent: 70),
          _buildSectionHeader('Lainnya'),
          _buildSettingsItem(
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            icon: Icons.info_outline,
            onTap: () {
              print('About setting tapped');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueAccent,  // Ganti warna header menjadi biru
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 24),  // Ganti ikon menjadi biru
      title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,  // Ganti warna switch aktif menjadi biru
        inactiveTrackColor: Colors.grey.shade300,  // Ganti warna track tidak aktif menjadi abu-abu
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 24),  // Ganti ikon menjadi biru
      title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 16),  // Ganti ikon panah menjadi biru
      onTap: onTap,
    );
  }
}
