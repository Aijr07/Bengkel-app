import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';       // <-- Impor Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';  // <-- Impor Firestore

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_fullNameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Harap isi semua field yang tersedia.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? newUser = userCredential.user;

      if (newUser != null) {
        await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set({
          'uid': newUser.uid,
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'customer',
          'createdAt': Timestamp.now(),
        });

        if (mounted) {
          _showSuccessDialog();
        }
      }

    } on FirebaseAuthException catch (e) {
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
      _showErrorDialog("Terjadi kesalahan yang tidak diketahui. Coba lagi.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrasi Berhasil'),
        content: const Text('Akun Anda telah berhasil dibuat. Silakan login.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Oke'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); 
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ganti background menjadi putih
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        backgroundColor: Colors.blueAccent, // Warna biru untuk AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Buat Akun Anda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[200]),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[200]),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(), filled: true, fillColor: Colors.grey[200]),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Daftar', style: TextStyle(fontSize: 18)),
                      ),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Kembali ke halaman login
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
