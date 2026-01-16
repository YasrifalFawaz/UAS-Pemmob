import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: WeatherService.getWeather(),
      builder: (_, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!s.hasData) {
          return const Center(child: Text('Gagal memuat cuaca'));
        }

        final data = s.data!;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data['icon'], size: 64, color: Colors.blue),
              const SizedBox(height: 12),
              Text(
                '${data['temp']}°C',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['weather'],
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
