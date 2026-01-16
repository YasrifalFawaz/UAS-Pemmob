import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherService {
  static Future<Map<String, dynamic>> getWeather() async {
    try {
      // Koordinat Gedung Sate, Bandung (titik paling akurat untuk pusat kota)
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=-6.9025&longitude=107.6188&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m&timezone=auto');

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final current = data['current'];
        final int code = current['weather_code'];

        return {
          'temp': current['temperature_2m'],
          'feels_like': current['apparent_temperature'], // Suhu yang dirasakan tubuh
          'humidity': current['relative_humidity_2m'],
          'wind': current['wind_speed_10m'],
          'weather': _getWeatherDesc(code),
          'icon': _getWeatherIcon(code),
        };
      }
    } catch (e) {
      print("Weather Error: $e");
    }
    return {'temp': 0, 'weather': 'Data tidak tersedia', 'icon': Icons.error};
  }

  static String _getWeatherDesc(int code) {
    // Mapping kode WMO yang lebih detail agar lebih akurat
    if (code == 0) return 'Langit Cerah';
    if (code == 1 || code == 2 || code == 3) return 'Sebagian Berawan';
    if (code == 45 || code == 48) return 'Berkabut';
    if (code >= 51 && code <= 55) return 'Gerimis';
    if (code >= 61 && code <= 65) return 'Hujan';
    if (code >= 95) return 'Hujan Badai & Petir';
    return 'Berawan';
  }

  static IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.wb_cloudy;
    if (code >= 61 && code <= 65) return Icons.umbrella;
    return Icons.cloud;
  }
}