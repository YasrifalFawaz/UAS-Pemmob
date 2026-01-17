import 'package:flutter/material.dart';
import '../../config/api.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
          title: const Text(
            'Tentang Aplikasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ================= HEADER =================
                Container(
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
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1B5E20).withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sports_soccer,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'MinSoc',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Aplikasi Booking Lapangan',
                          style: TextStyle(
                            color: Color(0xFF1B5E20),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================= DESKRIPSI =================
                _card(
                  'Deskripsi Aplikasi',
                  Icons.description,
                  const Text(
                    'MinSoc merupakan aplikasi mobile berbasis Flutter yang '
                    'digunakan untuk melakukan pemesanan lapangan mini soccer '
                    'secara online. Aplikasi ini membantu pengguna dalam '
                    'melihat jadwal, melakukan booking, serta memantau status '
                    'pemesanan dengan mudah dan cepat.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      height: 1.6,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ================= FITUR =================
                _card(
                  'Fitur Utama',
                  Icons.star,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Feature(
                        icon: Icons.calendar_month,
                        text: 'Booking Lapangan',
                        gradient: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      ),
                      SizedBox(height: 12),
                      _Feature(
                        icon: Icons.cloud,
                        text: 'Informasi Cuaca',
                        gradient: [Color(0xFF2E7D32), Color(0xFF43A047)],
                      ),
                      SizedBox(height: 12),
                      _Feature(
                        icon: Icons.admin_panel_settings,
                        text: 'Manajemen Booking Admin',
                        gradient: [Color(0xFF43A047), Color(0xFF66BB6A)],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ================= DEVELOPER =================
                _card(
                  'Tim Developer',
                  Icons.code,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Dev(
                        npm: '152023024',
                        name: 'Yasrifal Fawaz',
                        role: 'Backend Developer',
                        color: Color(0xFF1B5E20),
                      ),
                      SizedBox(height: 16),
                      _Dev(
                        npm: '152023152',
                        name: 'Martin Rizki Wendi S',
                        role: 'Mobile Developer',
                        color: Color(0xFF2E7D32),
                      ),
                      SizedBox(height: 16),
                      _Dev(
                        npm: '152023161',
                        name: 'Nouval M Abdul Rojak',
                        role: 'UI/UX Designer',
                        color: Color(0xFF43A047),
                      ),
                      SizedBox(height: 16),
                      _Dev(
                        npm: '152023162',
                        name: 'Muhammad Fadhlan Pratama',
                        role: 'Mobile Developer',
                        color: Color(0xFF66BB6A),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ================= API =================
                _card(
                  'API Cuaca',
                  Icons.api,
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF1B5E20).withOpacity(0.2),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        ApiConfig.weatherUrl,
                        style: const TextStyle(
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        color: Color(0xFF1B5E20),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '© 2026 MinSoc App',
                        style: TextStyle(
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booking Lapangan Jadi Lebih Mudah',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  static Widget _card(String title, IconData icon, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ================= FEATURE ITEM =================
class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Color> gradient;

  const _Feature({
    required this.icon,
    required this.text,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= DEV ITEM =================
class _Dev extends StatelessWidget {
  final String npm;
  final String name;
  final String role;
  final Color color;

  const _Dev({
    required this.npm,
    required this.name,
    required this.role,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  npm,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}