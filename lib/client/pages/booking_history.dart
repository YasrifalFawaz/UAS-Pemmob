import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingHistoryPage extends StatelessWidget {
  final int userId;
  const BookingHistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ClientBookingService.getUserBookings(userId),
      builder: (_, s) {
        if (!s.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (s.data!.isEmpty) {
          return const Center(child: Text('Belum ada booking'));
        }

        return ListView.builder(
          itemCount: s.data!.length,
          itemBuilder: (_, i) {
            final b = s.data![i];
            return ListTile(
              title: Text(b['tanggal']),
              subtitle: Text(
                'Jam ${b['jam_mulai']} | ${b['durasi']} jam',
              ),
              trailing: Chip(
                label: Text(b['status']),
              ),
            );
          },
        );
      },
    );
  }
}
