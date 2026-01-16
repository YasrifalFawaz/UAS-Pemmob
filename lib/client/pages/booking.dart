import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingPage extends StatefulWidget {
  final int userId;
  const BookingPage({super.key, required this.userId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  int? startHour; // pakai jam saja (int)
  int duration = 1;

  static const int tarif = 300000;
  int get total => duration * tarif;

  bool loading = false;

  bool isTodaySelected() {
    if (selectedDate == null) return false;
    final now = DateTime.now();
    return selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;
  }

  List<int> availableHours() {
    final now = DateTime.now();
    int start = 0;

    if (isTodaySelected()) {
      start = now.hour + 1;
    }

    return List.generate(24 - start, (i) => start + i);
  }

  Future<void> pickStartHour() async {
    final hours = availableHours();

    if (hours.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada jam tersedia hari ini')),
      );
      return;
    }

    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: 350,
          child: ListView.builder(
            itemCount: hours.length,
            itemBuilder: (_, i) {
              final h = hours[i];
              return ListTile(
                title: Text('${h.toString().padLeft(2, '0')}:00'),
                onTap: () => Navigator.pop(context, h),
              );
            },
          ),
        );
      },
    );

    if (picked != null) {
      setState(() => startHour = picked);
    }
  }

  Future<void> submitBooking() async {
    if (selectedDate == null || startHour == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi tanggal dan jam')),
      );
      return;
    }

    setState(() => loading = true);

    final tanggal = selectedDate!.toIso8601String().split('T')[0];
    final jamMulai = '${startHour!.toString().padLeft(2, '0')}:00:00';

    final success = await ClientBookingService.createBooking(
      userId: widget.userId,
      tanggal: tanggal,
      jamMulai: jamMulai,
      durasi: duration,
    );

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Booking berhasil' : 'Booking gagal / bentrok'),
      ),
    );

    if (success) {
      setState(() {
        selectedDate = null;
        startHour = null;
        duration = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Lapangan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// TANGGAL
              ListTile(
                leading: const Icon(Icons.date_range),
                title: Text(
                  selectedDate == null
                      ? 'Pilih tanggal'
                      : selectedDate!.toString().split(' ')[0],
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: DateTime(now.year + 1),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                      startHour = null;
                    });
                  }
                },
              ),

              /// JAM MULAI (SCROLL)
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  startHour == null
                      ? 'Pilih jam mulai'
                      : '${startHour!.toString().padLeft(2, '0')}:00',
                ),
                onTap: pickStartHour,
              ),

              /// DURASI (DROPDOWN FULL WIDTH)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 12),
                    const Text('Durasi'),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: duration,
                        items: List.generate(
                          24,
                          (i) => DropdownMenuItem(
                            value: i + 1,
                            child: Text('${i + 1} jam'),
                          ),
                        ),
                        onChanged: (v) => setState(() => duration = v!),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              /// TOTAL
              Text(
                'Total Biaya: Rp $total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : submitBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'BOOKING SEKARANG',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
