import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jangan lupa tambahkan 'intl: ^0.18.1' ke pubspec.yaml

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // State untuk menyimpan status checkbox
  final Map<String, bool> _services = {
    'Ganti Oli': false,
    'Servis Ringan': false,
    'Servis Berat': false,
    'Servis Aki': false,
  };

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan pemilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      // Tema gelap untuk date picker
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF32CD32), // Warna header
              onPrimary: Colors.black, // Warna teks header
              onSurface: Colors.white, // Warna teks tanggal
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'Halaman Pemesanan Service',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Bagian Pilih Servis
          const Text(
            'Pilih Servis',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildServiceCheckbox('Ganti Oli', Icons.opacity),
          const SizedBox(height: 12),
          _buildServiceCheckbox('Servis Ringan', Icons.build_circle_outlined),
          const SizedBox(height: 12),
          _buildServiceCheckbox('Servis Berat', Icons.build),
          const SizedBox(height: 12),
          _buildServiceCheckbox('Servis Aki', Icons.battery_charging_full),
          const SizedBox(height: 32),

          // Bagian Pilih Waktu Servis
          const Text(
            'Pilih Waktu Servis',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'dd-mm-yyyy',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Bagian Detail Tambahan
          const Text(
            'Detail Tambahan',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _detailsController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Masukkan tambahan spesifik servis',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Tombol Konfirmasi dengan showDialog yang telah dipercantik
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  // AlertDialog yang lebih menarik secara visual
                  return AlertDialog(
                    backgroundColor: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Color(0xFF32CD32),
                          size: 100,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Pemesanan Berhasil!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Jadwal servis Anda telah dikonfirmasi.Terima kasih',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 42, 76, 83),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // 1. Tutup dialog
                              Navigator.of(context).pop();
                              // 2. Kembali ke halaman sebelumnya
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Selesai',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 254, 254, 254), // Warna teks agar kontras
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 42, 76, 83),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Konfirmasi Servis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat item checkbox servis
  Widget _buildServiceCheckbox(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(icon, color: const Color(0xFF32CD32)),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
        value: _services[title],
        onChanged: (bool? value) {
          setState(() {
            _services[title] = value!;
          });
        },
        activeColor: const Color(0xFF32CD32),
        checkColor: Colors.black,
        controlAffinity: ListTileControlAffinity.trailing,
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}