import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/income_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('dd MMMM yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hari ini', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            today,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text('Jadwal Terisi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('15.00 - 19.00'),
              subtitle: const Text('Oleh: User ID 3'),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pendapatan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          IncomeChart(todayIncome: 120000),
        ],
      ),
    );
  }
}