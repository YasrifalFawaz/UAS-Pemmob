  import 'package:flutter/material.dart';
  import 'package:fl_chart/fl_chart.dart';
  import 'package:intl/intl.dart';
  import '../services/booking_service.dart';

  // Format Rupiah Rp 000.000
  final currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  class DashboardPage extends StatefulWidget {
    const DashboardPage({super.key});

    @override
    State<DashboardPage> createState() => _DashboardPageState();
  }

  class _DashboardPageState extends State<DashboardPage> {
    late Future<List<dynamic>> futureBookings;
    late DateTime selectedDate;

    @override
    void initState() {
      super.initState();
      selectedDate = DateTime.now();
      futureBookings = AdminBookingService.getAllBookings(); // FIXED
    }

    Future<void> _handleRefresh() async {
      setState(() {
        futureBookings = AdminBookingService.getAllBookings(); // FIXED
      });
    }

    Map<String, double> _calculateWeeklyIncome(List<dynamic> bookings) {
      Map<String, double> dailyIncome = {};
      for (int i = 6; i >= 0; i--) {
        String dateKey = DateFormat('dd/MM').format(DateTime.now().subtract(Duration(days: i)));
        dailyIncome[dateKey] = 0.0;
      }

      for (var b in bookings) {
        try {
          if (b['status'].toString().toLowerCase() == 'approved') {
            DateTime date = DateTime.parse(b['tanggal']);
            String dateKey = DateFormat('dd/MM').format(date);
            if (dailyIncome.containsKey(dateKey)) {
              double harga = double.tryParse(b['total_biaya'].toString().replaceAll(',', '')) ?? 0.0;
              dailyIncome[dateKey] = dailyIncome[dateKey]! + harga;
            }
          }
        } catch (_) {}
      }
      return dailyIncome;
    }

    int _countByStatus(List<dynamic> bookings, String status) {
      return bookings.where((b) => 
        b['status']?.toString().toLowerCase() == status.toLowerCase()
      ).length;
    }

    double _calculateTotalIncome(List<dynamic> bookings) {
      double total = 0;
      for (var b in bookings) {
        if (b['status']?.toString().toLowerCase() == 'approved') {
          total += double.tryParse(b['total_biaya']?.toString() ?? '0') ?? 0;
        }
      }
      return total;
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
              'Dashboard Admin',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
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

                final allData = snapshot.data ?? [];
                final incomeMap = _calculateWeeklyIncome(allData);
                final totalIncome = _calculateTotalIncome(allData);
                final pendingCount = _countByStatus(allData, 'pending');
                final approvedCount = _countByStatus(allData, 'approved');
                
                final filteredList = allData.where((b) {
                  try {
                    final date = DateTime.parse(b['tanggal']);
                    return date.year == selectedDate.year &&
                          date.month == selectedDate.month &&
                          date.day == selectedDate.day;
                  } catch (_) { return false; }
                }).toList();

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: SUMMARY CARDS
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Booking',
                              allData.length.toString(),
                              Icons.list,
                              const Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Pending',
                              pendingCount.toString(),
                              Icons.pending,
                              Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Approved',
                              approvedCount.toString(),
                              Icons.check_circle,
                              const Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Pendapatan',
                              currencyFormat.format(totalIncome),
                              Icons.payments,
                              const Color(0xFF43A047),
                              isLarge: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // SECTION 2: CHART PENDAPATAN
                      Container(
                        padding: const EdgeInsets.all(20),
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B5E20).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.bar_chart,
                                    color: Color(0xFF1B5E20),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Pendapatan 7 Hari Terakhir',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B5E20),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildIncomeChart(incomeMap),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // SECTION 3: JADWAL BOOKING HARI INI
                      Container(
                        padding: const EdgeInsets.all(20),
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFF1B5E20),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Jadwal Booking',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B5E20).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      _navIconButton(Icons.chevron_left, () {
                                        setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1)));
                                      }),
                                      Text(
                                        DateFormat('dd MMM').format(selectedDate),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1B5E20),
                                          fontSize: 13,
                                        ),
                                      ),
                                      _navIconButton(Icons.chevron_right, () {
                                        setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            if (filteredList.isEmpty)
                              _buildEmptyState()
                            else
                              ...filteredList.map((b) => _buildBookingItem(b)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Stat Card Widget
    Widget _buildStatCard(
      String label,
      String value,
      IconData icon,
      Color color, {
      bool isLarge = false,
    }) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: isLarge ? 16 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Tombol navigasi tanggal
    Widget _navIconButton(IconData icon, VoidCallback onTap) {
      return IconButton(
        icon: Icon(icon, color: const Color(0xFF1B5E20), size: 18),
        onPressed: onTap,
        splashRadius: 18,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    // Empty state
    Widget _buildEmptyState() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.event_busy,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tidak ada jadwal booking',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Bar Chart Widget
    Widget _buildIncomeChart(Map<String, double> incomeMap) {
      final values = incomeMap.values.toList();
      final labels = incomeMap.keys.toList();

      return SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: (values.isNotEmpty ? (values.reduce((a, b) => a > b ? a : b) * 1.2) : 1000000),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: const Color(0xFF1B5E20),
                getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                  currencyFormat.format(rod.toY),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < labels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(values.length, (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            )),
          ),
        ),
      );
    }

    // Booking Item Card
    Widget _buildBookingItem(dynamic b) {
      final status = b['status']?.toString().toLowerCase() ?? 'pending';
      Color statusColor = Colors.orange;
      if (status == 'approved') statusColor = const Color(0xFF1B5E20);
      if (status == 'rejected') statusColor = Colors.red;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_soccer,
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b['nama_user']?.toString() ?? "User #${b['user_id'] ?? '-'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${b['jam_mulai'] ?? '-'} - ${b['jam_selesai'] ?? '-'} (${b['durasi']} Jam)",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(
                    double.tryParse(b['total_biaya']?.toString() ?? '0') ?? 0
                  ),
                  style: const TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }