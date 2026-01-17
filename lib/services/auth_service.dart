import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class AuthService {
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  // PERBAIKAN: Register sekarang mengembalikan data user seperti login
  static Future<Map<String, dynamic>?> register(
      String nama, String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
      }),
    );
    
    if (res.statusCode == 200) {
      // Kembalikan data user (id, role, dll) dari response
      return jsonDecode(res.body);
    }
    return null;
  }
}