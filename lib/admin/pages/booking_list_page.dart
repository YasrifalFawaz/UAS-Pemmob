import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../widgets/booking_card.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<List<dynamic>> futureBookings;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memicu muat ulang data dari API
  void _loadData() {
    setState(() {
      futureBookings = AdminBookingService.getAllBookings();
    });
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Daftar Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadData(),
            color: const Color(0xFF1B5E20),
            child: FutureBuilder<List<dynamic>>(
              future: futureBookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
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
                                color: Colors.red.shade50,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 80,
                                color: Colors.red.shade400,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Terjadi Kesalahan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tidak dapat memuat data.\nTarik ke bawah untuk refresh.',
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

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
                                Icons.calendar_today,
                                size: 80,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Belum Ada Booking',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada data booking saat ini.\nTarik ke bawah untuk refresh.',
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

                final bookings = snapshot.data!;

                // Filter bookings by status
                final pendingBookings = bookings.where((b) => 
                  b['status']?.toString().toLowerCase() == 'pending'
                ).toList();
                final approvedBookings = bookings.where((b) => 
                  b['status']?.toString().toLowerCase() == 'approved'
                ).toList();
                final rejectedBookings = bookings.where((b) => 
                  b['status']?.toString().toLowerCase() == 'rejected'
                ).toList();

                return ListView(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // Summary cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Total',
                              bookings.length,
                              Icons.list,
                              const Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Pending',
                              pendingBookings.length,
                              Icons.pending,
                              Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pending bookings section
                    if (pendingBookings.isNotEmpty) ...[
                      _buildSectionHeader('Menunggu Konfirmasi', pendingBookings.length),
                      ...pendingBookings.map((booking) => BookingCard(
                        booking: booking,
                        onRefresh: _loadData,
                      )),
                      const SizedBox(height: 12),
                    ],

                    // Approved bookings section
                    if (approvedBookings.isNotEmpty) ...[
                      _buildSectionHeader('Disetujui', approvedBookings.length),
                      ...approvedBookings.map((booking) => BookingCard(
                        booking: booking,
                        onRefresh: _loadData,
                      )),
                      const SizedBox(height: 12),
                    ],

                    // Rejected bookings section
                    if (rejectedBookings.isNotEmpty) ...[
                      _buildSectionHeader('Ditolak', rejectedBookings.length),
                      ...rejectedBookings.map((booking) => BookingCard(
                        booking: booking,
                        onRefresh: _loadData,
                      )),
                    ],

                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Color(0xFF1B5E20),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}