import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';

class BookingHistoryPage extends StatefulWidget {
  final int userId;
  const BookingHistoryPage({super.key, required this.userId});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  Future<void> _handleRefresh() async {
    setState(() {});
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      print('📅 Raw date from API: $dateStr'); // DEBUG
      
      // Parse tanggal - PERBAIKAN: Parse sebagai UTC lalu convert ke local
      DateTime date;
      if (dateStr.contains('T')) {
        // Format: 2026-01-17T00:00:00.000Z
        date = DateTime.parse(dateStr).toLocal();
      } else {
        // Format: 2026-01-17
        // Buat DateTime lokal tanpa konversi timezone
        final parts = dateStr.split('-');
        date = DateTime(
          int.parse(parts[0]), // year
          int.parse(parts[1]), // month
          int.parse(parts[2]), // day
        );
      }
      
      print('📅 Parsed DateTime: ${date.day}/${date.month}/${date.year}'); // DEBUG
      
      // Format untuk ditampilkan
      final formatted = DateFormat('d MMM yyyy').format(date);
      
      print('📅 Formatted date: $formatted'); // DEBUG
      
      return formatted;
    } catch (e) {
      print('❌ Date parsing error: $e for input: $dateStr'); // DEBUG
      return dateStr;
    }
  }

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
            'Riwayat Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: const Color(0xFF1B5E20),
          child: FutureBuilder<List<dynamic>>(
            future: ClientBookingService.getUserBookings(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                );
              }

              // DEBUG: Print data yang diterima
              if (snapshot.hasData) {
                print('🔍 Total bookings received: ${snapshot.data!.length}');
                for (var booking in snapshot.data!) {
                  print('📦 Booking data: $booking');
                }
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    Container(
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1B5E20).withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.history,
                              size: 80,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Belum Ada Riwayat',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Anda belum memiliki riwayat booking.\nMulai booking lapangan sekarang!',
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
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, i) {
                  final b = snapshot.data![i];
                  final Color statusColor = _getStatusColor(b['status']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          // Header dengan gradient
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  statusColor.withOpacity(0.8),
                                  statusColor,
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _getStatusIcon(b['status']),
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
                                        _formatDate(b['tanggal']),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        b['status'].toString().toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${b['durasi']} Jam',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Detail section
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Icons.access_time,
                                  iconColor: const Color(0xFF1B5E20),
                                  label: 'Jam Mulai',
                                  value: b['jam_mulai'] ?? '-',
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.sports_soccer,
                                  iconColor: const Color(0xFF2E7D32),
                                  label: 'Lapangan',
                                  value: b['lapangan'] ?? 'Lapangan Utama',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(dynamic status) {
    String s = status?.toString().toLowerCase() ?? 'pending';
    if (s == 'approved' || s == 'success' || s == 'selesai') {
      return Icons.check_circle;
    }
    if (s == 'rejected' || s == 'failed' || s == 'dibatalkan') {
      return Icons.cancel;
    }
    return Icons.pending;
  }

  Color _getStatusColor(dynamic status) {
    String s = status?.toString().toLowerCase() ?? 'pending';
    if (s == 'approved' || s == 'success') return const Color(0xFF1B5E20);
    if (s == 'rejected' || s == 'failed') return Colors.red.shade700;
    return Colors.orange.shade700;
  }
}