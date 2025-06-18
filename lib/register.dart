import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background sangat gelap
      appBar: AppBar(
        // AppBar dengan gaya yang sesuai
        backgroundColor: const Color.fromARGB(255, 42, 76, 83),
        elevation: 0,
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
        // Tombol kembali otomatis akan muncul karena kita menggunakan Navigator.push
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container untuk form register
                Container(
                  padding: const EdgeInsets.all(32.0),
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 42, 76, 83), // Warna container form
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Selamat Datang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Username Text Field
                      _buildTextField(hint: 'Username', obscureText: false),
                      const SizedBox(height: 20),

                      // Email Text Field
                      _buildTextField(hint: 'Email', obscureText: false),
                      const SizedBox(height: 20),
                      
                      // Password Text Field
                      _buildTextField(hint: 'Password', obscureText: true),
                      const SizedBox(height: 32),
                      
                      // Tombol Daftar
                      ElevatedButton(
                        onPressed: () {
                          // Logika pendaftaran, bisa kembali ke login setelah sukses
                           Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Link "Masuk"
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            const TextSpan(text: 'Sudah punya akun? '),
                            TextSpan(
                              text: 'Masuk',
                              style: const TextStyle(
                                color: Colors.white, // Warna link
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Kembali ke halaman sebelumnya (login)
                                  Navigator.pop(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk TextField
  Widget _buildTextField({required String hint, required bool obscureText}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2C2C2C), // Warna field input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}