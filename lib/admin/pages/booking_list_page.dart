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
      futureBookings = AdminBookingService.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan RefreshIndicator agar admin bisa tarik layar ke bawah untuk refresh
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: FutureBuilder<List<dynamic>>(
          future: futureBookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView( // Pakai ListView supaya bisa di-refresh walau kosong
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  const Center(child: Text('Tidak ada data booking.')),
                ],
              );
            }

            final bookings = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                // MENGGUNAKAN BOOKING CARD YANG KAMU BUAT
                return BookingCard(
                  booking: bookings[index],
                  onRefresh: _loadData, // Kirim fungsi refresh ke dalam card
                );
              },
            );
          },
        ),
      ),
    );
  }
}