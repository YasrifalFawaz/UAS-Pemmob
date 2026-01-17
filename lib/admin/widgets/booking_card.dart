import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';

class BookingCard extends StatelessWidget {
  final Map booking;
  final VoidCallback onRefresh;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onRefresh,
  });

  Color _getStatusColor() {
    final status = booking['status']?.toString().toLowerCase() ?? 'pending';
    if (status == 'approved') return const Color(0xFF1B5E20);
    if (status == 'rejected') return Colors.red.shade700;
    return Colors.orange.shade700;
  }

  IconData _getStatusIcon() {
    final status = booking['status']?.toString().toLowerCase() ?? 'pending';
    if (status == 'approved') return Icons.check_circle;
    if (status == 'rejected') return Icons.cancel;
    return Icons.pending;
  }

  String _getStatusText() {
    final status = booking['status']?.toString().toLowerCase() ?? 'pending';
    if (status == 'approved') return 'Disetujui';
    if (status == 'rejected') return 'Ditolak';
    return 'Menunggu';
  }

  // Fungsi untuk format tanggal
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    
    try {
      DateTime date;
      if (dateStr.contains('T')) {
        date = DateTime.parse(dateStr).toLocal();
      } else {
        final parts = dateStr.split('-');
        date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
      
      // Format tanpa locale dulu (English)
      return DateFormat('d MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  // Fungsi untuk format jam
  String _formatJam(String? jam) {
    if (jam == null || jam.isEmpty) return '-';
    
    try {
      if (jam.length == 5 && jam.contains(':')) {
        return jam;
      }
      DateTime dateTime = DateTime.parse(jam);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return jam;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      _getStatusIcon(),
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
                          _formatDate(booking['tanggal']),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getStatusText(),
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
                      '${booking['durasi']} Jam',
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
                    value: _formatJam(booking['jam_mulai']),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.person,
                    iconColor: const Color(0xFF2E7D32),
                    label: 'Pemesan',
                    value: booking['nama_user'] ?? 'User #${booking['user_id'] ?? '-'}',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.sports_soccer,
                    iconColor: const Color(0xFF43A047),
                    label: 'Lapangan',
                    value: booking['lapangan'] ?? 'Lapangan Utama',
                  ),

                  // Action buttons untuk status pending
                  if (booking['status'] == 'pending') ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.close, size: 20),
                            label: const Text(
                              'Tolak',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              final confirm = await _showConfirmDialog(
                                context,
                                'Tolak Booking',
                                'Apakah Anda yakin ingin menolak booking ini?',
                                Colors.red.shade700,
                              );
                              if (confirm == true) {
                                await AdminBookingService.reject(booking['id']);
                                onRefresh();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check, size: 20),
                            label: const Text(
                              'Setujui',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B5E20),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              final confirm = await _showConfirmDialog(
                                context,
                                'Setujui Booking',
                                'Apakah Anda yakin ingin menyetujui booking ini?',
                                const Color(0xFF1B5E20),
                              );
                              if (confirm == true) {
                                await AdminBookingService.approve(booking['id']);
                                onRefresh();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
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

  Future<bool?> _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    Color color,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_outline,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );
  }
}