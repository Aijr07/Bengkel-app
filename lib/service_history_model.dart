// lib/service_history_model.dart

class ServiceHistoryModel {
  final String id;
  final List<String> services; // Akan menyimpan nama-nama servis seperti 'Ganti Oli'
  final String date;
  final int totalPrice;
  final String? details;

  ServiceHistoryModel({
    required this.id,
    required this.services,
    required this.date,
    required this.totalPrice,
    this.details,
  });
}