// lib/Login.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Impor halaman-halaman tujuan
import 'package:flutter_application_1/Home.dart'; 
// Nanti kita akan buat halaman Admin, untuk sekarang kita siapkan impornya
// import 'package:flutter_application_1/admin_dashboard_page.dart'; 

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- FUNGSI UTAMA UNTUK PROSES LOGIN ---
  Future<void> _loginUser() async {
  final input = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (input.isEmpty || password.isEmpty) {
    _showErrorDialog("Harap isi email atau username dan password.");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final email = await _getEmailFromUsername(input);

    if (email == null) {
      _showErrorDialog("Akun dengan username/email tersebut tidak ditemukan.");
      setState(() => _isLoading = false);
      return;
    }

    // Login seperti biasa dengan email dan password
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null && mounted) {
      await _checkUserRoleAndNavigate(user.uid);
    }

  } on FirebaseAuthException catch (e) {
    String errorMessage = "Email atau password salah.";
    if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
      errorMessage = "Email atau password yang Anda masukkan salah.";
    }
    _showErrorDialog(errorMessage);
  } catch (e) {
    _showErrorDialog("Terjadi kesalahan. Periksa koneksi internet Anda.");
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<String?> _getEmailFromUsername(String input) async {
  if (input.contains('@')) {
    // Input sudah berupa email
    return input;
  }

  // Jika input berupa username, cari email-nya di Firestore
  final query = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isEqualTo: input)
      .limit(1)
      .get();

  if (query.docs.isNotEmpty) {
    return query.docs.first.data()['email'];
  }

  return null; // Tidak ditemukan
}

  // --- FUNGSI UNTUK MEMERIKSA PERAN DAN NAVIGASI ---
  Future<void> _checkUserRoleAndNavigate(String uid) async {
    try {
      // 3. Ambil data pengguna dari Firestore berdasarkan UID
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists && mounted) {
        // 4. Ambil nilai field 'role' dari dokumen
        final userData = docSnapshot.data() as Map<String, dynamic>;
        final String role = userData['role'];

        // 5. Lakukan navigasi berdasarkan peran
        if (role == 'admin') {
            // Jika peran adalah 'admin', navigasi ke halaman admin
            Navigator.pushReplacementNamed(context, '/admin_dashboard');
          

        } else {
          // Jika peran adalah 'customer' atau lainnya, navigasi ke Halaman Utama
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Ini kasus langka: user ada di Auth tapi tidak ada di Firestore
        _showErrorDialog("Data pengguna tidak ditemukan.");
      }
    } catch (e) {
       _showErrorDialog("Gagal mengambil data pengguna.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Gagal'),
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

  @override
  Widget build(BuildContext context) {
    // Anda bisa menggunakan UI halaman login Anda yang sudah ada
    // Ini hanya contoh UI sederhana
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang Kembali!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email atau Username', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[800]),
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color.fromARGB(255, 42, 76, 83),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
              TextButton(
                onPressed: () {
                  // Arahkan ke halaman registrasi
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Belum punya akun? Daftar di sini'),
              )
            ],
          ),
        ),
      ),
    );
  }
}