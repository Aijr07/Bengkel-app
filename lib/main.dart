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
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        // Tambahkan provider lain jika ada
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      initialRoute: '/login',
      routes: {
        "/home": (context) => const HomePage(),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/booking": (context) => const BookingPage(),
        "/riwayat": (context) => const HistoryPage(),
        "/profil": (context) => const ProfilePage(),
        "/setting": (context) => const SettingsPage(),
        "/status": (context) => const StatusServicePage(),
        "/aboutus": (context) => const AboutUsPage(),
        "/admin_dashboard": (context) => const AdminDashboardPage(),
      },
    );
  }
}
