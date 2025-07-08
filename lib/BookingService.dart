// lib/BookingService.dart (Versi Lengkap)

import 'package:flutter/material.dart';
import 'package:flutter_application_1/booking_database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'history_provider.dart';
import 'service_history_model.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Data servis beserta harga dan status pilihannya
  final Map<String, Map<String, dynamic>> _services = {
    'Ganti Oli': {'price': 150000, 'selected': false, 'icon': Icons.opacity},
    'Servis Ringan': {'price': 250000, 'selected': false, 'icon': Icons.build_circle_outlined},
    'Servis Berat': {'price': 750000, 'selected': false, 'icon': Icons.build},
    'Servis Aki': {'price': 100000, 'selected': false, 'icon': Icons.battery_charging_full},
  };

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _dateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Fungsi utama untuk memproses dan menyimpan pemesanan
  Future<void> _submitBooking() async {
  final List<String> selectedServices = [];
  _services.forEach((key, value) {
    if (value['selected'] == true) {
      selectedServices.add(key);
    }
  });

  final int totalPrice = _calculateTotalPrice();
  final String date = _dateController.text;
  final String details = _detailsController.text;

  if (selectedServices.isEmpty || date.isEmpty) {
    _showErrorDialog("Harap pilih minimal satu servis dan tentukan tanggal.");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showErrorDialog("Anda harus login terlebih dahulu untuk membuat pesanan.");
      setState(() => _isLoading = false);
      return;
    }

    final customerName = user.displayName ?? user.email ?? 'Pelanggan';

    final booking = {
      'customerId': user.uid,
      'customerName': customerName,
      'orderDate': date,
      'services': selectedServices.join(','), // Disimpan sebagai string
      'totalPrice': totalPrice,
      'details': details,
      'status': 'Pesanan Diterima',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await BookingDatabase.instance.insertBooking(booking);

    final newHistory = ServiceHistoryModel(
      id: DateTime.now().toIso8601String(),
      services: selectedServices,
      date: date,
      totalPrice: totalPrice,
      details: details,
    );

    if (mounted) {
      Provider.of<HistoryProvider>(context, listen: false).addHistory(newHistory);
      _showSuccessDialog(totalPrice);
    }

  } catch (e) {
    _showErrorDialog("Gagal menyimpan pesanan. Silakan coba lagi.");
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  // --- Widget Helper dan Fungsi Lainnya ---

  int _calculateTotalPrice() {
    int total = 0;
    _services.forEach((key, value) {
      if (value['selected'] == true) {
        total += value['price'] as int;
      }
    });
    return total;
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: Color(0xFF32CD32), onPrimary: Colors.black, onSurface: Colors.white)), child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Error'), content: Text(message), actions: [TextButton(child: const Text('Oke'), onPressed: () => Navigator.of(ctx).pop())]));
  }

  void _showSuccessDialog(int totalPrice) {
    if (!mounted) return;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog(title: const Text('Pemesanan Berhasil'), content: Text('Total pembayaran Anda adalah ${currencyFormatter.format(totalPrice)}. Admin akan segera memproses pesanan Anda.'), actions: [TextButton(child: const Text('Selesai'), onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); })]));
  }
  
  // Widget untuk membuat setiap baris checkbox servis
  Widget _buildServiceCheckbox(String title) {
    final service = _services[title]!;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Row(
          children: [
            Icon(service['icon'] as IconData, color: const Color(0xFF32CD32)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 4),
                Text(currencyFormatter.format(service['price']), style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ],
        ),
        value: service['selected'],
        onChanged: (bool? value) {
          setState(() {
            _services[title]!['selected'] = value!;
          });
        },
        activeColor: const Color(0xFF32CD32),
        checkColor: Colors.black,
        controlAffinity: ListTileControlAffinity.trailing,
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
        title: const Text('Halaman Pemesanan Service', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text('Pilih Servis', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._services.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildServiceCheckbox(entry.key),
            );
          }).toList(),
          const SizedBox(height: 20),
          
          const Text('Pilih Waktu Servis', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(hintText: 'dd-mm-yyyy', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2C2C2C), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 32),
          
          const Text('Detail Tambahan', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _detailsController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(hintText: 'Masukkan tambahan spesifik servis', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2C2C2C), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Harga', style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text(currencyFormatter.format(_calculateTotalPrice()), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 42, 76, 83), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Konfirmasi Servis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
        ],
      ),
    );
  }
}