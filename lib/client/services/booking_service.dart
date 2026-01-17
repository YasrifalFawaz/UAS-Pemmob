import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';

class ClientBookingService {
  static Future<List<dynamic>> getUserBookings(int userId) async {
    try {
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/bookings/user/$userId'),
        headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print('Client booking error: $e');
    }
    return [];
  }

  static Future<bool> createBooking({
    required int userId,
    required String tanggal,
    required String jamMulai,
    required int durasi,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'user_id': userId,
          'tanggal': tanggal,
          'jam_mulai': jamMulai,
          'durasi': durasi,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
