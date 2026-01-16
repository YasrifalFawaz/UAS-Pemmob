import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeChart extends StatelessWidget {
  // Tambahkan parameter agar nilai pendapatan bisa dikirim dari Dashboard
  final double todayIncome;

  IncomeChart({super.key, required this.todayIncome});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          // Menghilangkan garis grid agar tampilan lebih simpel
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          
          // Hanya satu group data untuk hari ini
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: todayIncome, 
                  color: Colors.blue, 
                  width: 40, // Diperlebar karena hanya satu batang
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
          ],
          
          titlesData: FlTitlesData(
            // Sembunyikan judul atas dan kanan
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            
            // Pengaturan angka di samping kiri
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  // Format angka ke ribuan (rb) agar tidak terlalu panjang
                  if (value == 0) return const SizedBox();
                  return Text(
                    '${(value / 1000).toInt()}rb',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            
            // Pengaturan label bawah
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Hari Ini', 
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}