import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlue],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: WeatherService.getWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            
            final data = snapshot.data!;
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("BANDUNG", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  const SizedBox(height: 10),
                  Icon(data['icon'], size: 100, color: Colors.white),
                  Text('${data['temp']}°', style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w200)),
                  Text(data['weather'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
                  const SizedBox(height: 40),
                  
                  // Detail Cuaca Ekstra
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _weatherDetail("Suhu", "${data['feels_like']}°", Icons.thermostat),
                      _weatherDetail("Kecepatan Angin", "${data['wind']} km/h", Icons.air),
                      _weatherDetail("Kelembapan", "${data['humidity']}%", Icons.water_drop),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _weatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}