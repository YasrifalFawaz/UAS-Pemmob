import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>> getWeather() async {
    final res = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=-6.9&longitude=107.6&current_weather=true',
    ));

    final data = jsonDecode(res.body);
    final code = data['current_weather']['weathercode'];

    return {
      'temp': data['current_weather']['temperature'],
      'code': code,
    };
  }
}
