import 'package:flutter/material.dart';
import 'package:flutter_application_1/booking_service.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/profil.dart';
import 'package:flutter_application_1/register.dart';
import 'package:flutter_application_1/riwayat_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login(),
        theme: ThemeData(useMaterial3: false),
        routes:{
          "/home": (context) =>Home(),
          "/login": (context) =>login(),
          "/register": (context) =>Register(),
          "/booking": (context) =>BookingPage(),
          "/riwayat": (context) =>HistoryPage(),
          "/profil": (context) =>ProfilePage(),
        } ,
    );
  }
}
