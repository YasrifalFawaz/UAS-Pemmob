import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF43A047),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Cuaca Hari Ini',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: WeatherService.getWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.shade50,
                        ),
                        child: Icon(
                          Icons.cloud_off,
                          size: 80,
                          color: Colors.red.shade400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Gagal Memuat Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak dapat mengambil data cuaca.\nPeriksa koneksi internet Anda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data!;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Main weather card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Location
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B5E20).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xFF1B5E20),
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "BANDUNG",
                                  style: TextStyle(
                                    color: Color(0xFF1B5E20),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Weather icon & temp
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              key: ValueKey(data['temp']),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF1B5E20).withOpacity(0.1),
                                        const Color(0xFF43A047).withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    data['icon'],
                                    size: 100,
                                    color: const Color(0xFF1B5E20),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${data['temp']}°',
                                  style: const TextStyle(
                                    color: Color(0xFF1B5E20),
                                    fontSize: 72,
                                    fontWeight: FontWeight.w300,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['weather'].toString().toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Weather details grid
                    Row(
                      children: [
                        Expanded(
                          child: _weatherDetailCard(
                            label: "Terasa Seperti",
                            value: "${data['feels_like']}°",
                            icon: Icons.thermostat,
                            gradient: const [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _weatherDetailCard(
                            label: "Kecepatan Angin",
                            value: "${data['wind']} km/h",
                            icon: Icons.air,
                            gradient: const [Color(0xFF2E7D32), Color(0xFF43A047)],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Humidity card full width
                    _weatherDetailCard(
                      label: "Kelembapan",
                      value: "${data['humidity']}%",
                      icon: Icons.water_drop,
                      gradient: const [Color(0xFF43A047), Color(0xFF66BB6A)],
                      fullWidth: true,
                    ),

                    const SizedBox(height: 20),

                    // Info footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sports_soccer,
                            color: Color(0xFF1B5E20),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Kondisi cuaca sempurna untuk main futsal!',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _weatherDetailCard({
    required String label,
    required String value,
    required IconData icon,
    required List<Color> gradient,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}