import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';// Sesuaikan dengan path halaman register Anda

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🔑 Fungsi utama login
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

      // 🔐 Login dengan email dan password
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
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

  // 🔍 Fungsi untuk mendeteksi apakah input adalah email atau username
  Future<String?> _getEmailFromUsername(String input) async {
    if (input.contains('@')) {
      return input; // Sudah email
    }

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('fullName', isEqualTo: input)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data()['email'];
    }

    return null; // Tidak ditemukan
  }

  // 📦 Ambil role user dan arahkan ke halaman sesuai
  Future<void> _checkUserRoleAndNavigate(String uid) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists && mounted) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        final String role = userData['role'];

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
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
        actions: [
          TextButton(
            child: const Text('Oke'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Ganti background menjadi putih
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,  // Warna biru untuk AppBar
        elevation: 0,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang Kembali!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Email atau Username',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black),
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
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Belum punya akun? Daftar di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
