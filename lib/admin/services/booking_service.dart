import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';

class AdminBookingService {
  static Future<List<dynamic>> getAll() async {
    final res =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/bookings'));
    return jsonDecode(res.body);
  }

  static Future<void> approve(int id) async {
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}/bookings/$id/approve'),
    );
  }

  static Future<void> reject(int id) async {
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}/bookings/$id/reject'),
    );
  }
}
