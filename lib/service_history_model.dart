class ServiceHistoryModel {
  final String id;
  final List<String> services; 
  final String date;
  final int totalPrice;
  final String? details;
  String status;  // Pastikan status ada di model ini

  ServiceHistoryModel({
    required this.id,
    required this.services,
    required this.date,
    required this.totalPrice,
    this.details,
    required this.status,  // Tambahkan status dalam constructor
  });

  // Tambahkan setter untuk status jika belum ada
  set setStatus(String newStatus) {
    this.status = newStatus;
  }
}
