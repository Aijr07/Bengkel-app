// lib/Register.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';       // <-- Impor Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';  // <-- Impor Firestore

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controller untuk mengambil input dari text field
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State untuk menampilkan loading indicator saat proses registrasi berjalan
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- FUNGSI UTAMA UNTUK PROSES REGISTRASI ---
  Future<void> _registerUser() async {
    // Validasi sederhana, pastikan semua field terisi
    if (_fullNameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Harap isi semua field yang tersedia.");
      return;
    }

    // Tampilkan loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Buat pengguna baru di Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Ambil objek pengguna yang baru dibuat
      User? newUser = userCredential.user;

      if (newUser != null) {
        // 2. Simpan informasi tambahan (termasuk role) ke Firestore
        await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set({
          'uid': newUser.uid,
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'customer', // <-- Peran default untuk semua pendaftar baru
          'createdAt': Timestamp.now(),
        });
        
        // Jika berhasil, kembali ke halaman sebelumnya (login) setelah menampilkan dialog sukses
        if (mounted) {
          _showSuccessDialog();
        }
      }

    } on FirebaseAuthException catch (e) {
      // Tangani error spesifik dari Firebase Auth
      String errorMessage = "Terjadi kesalahan.";
      if (e.code == 'weak-password') {
        errorMessage = 'Password yang dimasukkan terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email ini sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      // Tangani error umum lainnya
      _showErrorDialog("Terjadi kesalahan yang tidak diketahui. Coba lagi.");
    } finally {
      // Sembunyikan loading indicator
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrasi Gagal'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Oke'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
  
  // Helper untuk menampilkan dialog sukses
  void _showSuccessDialog() {
      showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa menutup dialog dengan klik di luar
      builder: (ctx) => AlertDialog(
        title: const Text('Registrasi Berhasil'),
        content: const Text('Akun Anda telah berhasil dibuat. Silakan login.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Oke'),
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog
              Navigator.of(context).pop(); // Kembali ke halaman login
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan UI halaman registrasi
    // Anda bisa menyesuaikan ini dengan desain Anda sendiri
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Buat Akun Anda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[800]),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[800]),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[800]),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              // Tombol akan menampilkan loading jika _isLoading true
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color.fromARGB(255, 42, 76, 83),
                        ),
                        child: const Text('Daftar', style: TextStyle(fontSize: 18)),
                      ),
                    ),
              TextButton(
                onPressed: () {
                  // Kembali ke halaman login
                  Navigator.of(context).pop();
                },
                child: const Text('Sudah punya akun? Login di sini'),
              )
            ],
          ),
        ),
      ),
    );
  }
}