import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';

// ========== CLIENT BOOKING SERVICE ==========
class ClientBookingService {
  static Future<List<dynamic>> getUserBookings(int userId) async {
    try {
      print('🔍 Fetching bookings for userId: $userId');
      
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/bookings/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print('📥 Response status: ${res.statusCode}');
      print('📥 Response body: ${res.body}');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print('✅ Bookings found: ${data.length}');
        return data;
      } else {
        print('❌ Failed to get bookings: ${res.statusCode}');
      }
    } catch (e) {
      print('❌ Client booking error: $e');
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
      final payload = {
        'user_id': userId,
        'tanggal': tanggal,
        'jam_mulai': jamMulai,
        'durasi': durasi,
      };
      
      print('📤 Creating booking with payload: $payload');
      
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(payload),
      );
      
      print('📥 Create booking response: ${res.statusCode}');
      print('📥 Response body: ${res.body}');
      
      if (res.statusCode == 200) {
        print('✅ Booking created successfully!');
        return true;
      } else {
        print('❌ Booking failed: ${res.statusCode} - ${res.body}');
        return false;
      }
    } catch (e) {
      print('❌ Create booking error: $e');
      return false;
    }
  }
}

// ========== ADMIN BOOKING SERVICE ==========
class AdminBookingService {
  // Get all bookings
  static Future<List<dynamic>> getAllBookings() async {
    try {
      print('🔍 Admin: Fetching all bookings');
      
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/bookings'),
        headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      );

      print('📥 Response status: ${res.statusCode}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print('✅ Total bookings: ${data.length}');
        return data;
      }
    } catch (e) {
      print('❌ Admin get bookings error: $e');
    }
    return [];
  }

  // Approve booking
  static Future<bool> approve(int bookingId) async {
    try {
      print('✅ Approving booking ID: $bookingId');
      
      final res = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/bookings/$bookingId/approve'),
        headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      );

      print('📥 Approve response: ${res.statusCode}');
      
      if (res.statusCode == 200) {
        print('✅ Booking approved successfully!');
        return true;
      } else {
        print('❌ Approve failed: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Approve error: $e');
      return false;
    }
  }

  // Reject booking
  static Future<bool> reject(int bookingId) async {
    try {
      print('❌ Rejecting booking ID: $bookingId');
      
      final res = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/bookings/$bookingId/reject'),
        headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      );

      print('📥 Reject response: ${res.statusCode}');
      
      if (res.statusCode == 200) {
        print('✅ Booking rejected successfully!');
        return true;
      } else {
        print('❌ Reject failed: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Reject error: $e');
      return false;
    }
  }

  // Delete booking (optional)
  static Future<bool> deleteBooking(int bookingId) async {
    try {
      print('🗑️ Deleting booking ID: $bookingId');
      
      final res = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/bookings/$bookingId'),
        headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      );

      if (res.statusCode == 200) {
        print('✅ Booking deleted successfully!');
        return true;
      } else {
        print('❌ Delete failed: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Delete error: $e');
      return false;
    }
  }
}