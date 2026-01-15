import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherService.getWeather(),
      builder: (_, s) {
        if (!s.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = s.data!;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud, size: 64),
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
