import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';

class AdminUserService {
  static Future<List<dynamic>> getAll() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users'),
    );
    return res.statusCode == 200 ? jsonDecode(res.body) : [];
  }

  static Future<bool> create(
  String nama,
  String email,
  String password,
  String role,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
        'role': role, // 🔴 WAJIB
      }),
    );

    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');

    return res.statusCode == 200 || res.statusCode == 201;
  }


static Future<bool> update(
  int id,
  String nama,
  String email,
  String role,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'role': role, // 🔴 WAJIB
      }),
    );

    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');

    return res.statusCode == 200;
  }


  static Future<bool> delete(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/users/$id'),
    );
    return res.statusCode == 200;
  }
}
