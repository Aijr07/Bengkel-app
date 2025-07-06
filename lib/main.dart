import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Aboutus.dart';
import 'package:flutter_application_1/BookingService.dart';
import 'package:flutter_application_1/Home.dart';
import 'package:flutter_application_1/Login.dart';
import 'package:flutter_application_1/Profil.dart';
import 'package:flutter_application_1/Register.dart';
import 'package:flutter_application_1/RiwayatService.dart';
import 'package:flutter_application_1/Setting.dart';
import 'package:flutter_application_1/Status.dart';
import 'package:flutter_application_1/history_provider.dart';
import 'package:flutter_application_1/admin_dashboard_page.dart';
import 'package:provider/provider.dart';// <-- Impor firebase_core
import 'firebase_options.dart'; 

void main() async { // <-- Ubah menjadi async
  // Pastikan semua widget Flutter sudah siap sebelum menjalankan Firebase
  WidgetsFlutterBinding.ensureInitialized(); 

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Jalankan aplikasi Anda setelah Firebase siap
  runApp(
    ChangeNotifierProvider(
      create: (context) => HistoryProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login(),
        theme: ThemeData(useMaterial3: false),
        routes:{
          "/home": (context) =>HomePage(),
          "/login": (context) =>login(),
          "/register": (context) =>Register(),
          "/booking": (context) =>BookingPage(),
          "/riwayat": (context) =>HistoryPage(),
          "/profil": (context) =>ProfilePage(),
          "/setting": (context) =>SettingsPage(),
          "/status": (context) =>StatusServicePage(),
          "/aboutus": (context) =>AboutUsPage(),
          "/admin_dashboard": (context) => const AdminDashboardPage(),
        } ,
    );
  }
}
