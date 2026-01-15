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
  TimeOfDay? startTime;
  int duration = 1;

  static const int tarif = 300000;
  int get total => duration * tarif;

  bool loading = false;

  Future<void> submitBooking() async {
    if (selectedDate == null || startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi tanggal dan jam')),
      );
      return;
    }

    setState(() => loading = true);

    final tanggal =
    selectedDate!.toIso8601String().split('T')[0]; // yyyy-mm-dd
    final jamMulai =
        '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00';

    final success = await ClientBookingService.createBooking(
      userId: widget.userId,
      tanggal: tanggal,
      jamMulai: jamMulai,
      durasi: duration,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil')),
      );

      setState(() {
        selectedDate = null;
        startTime = null;
        duration = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking gagal / jadwal bentrok')),
      );
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
                    firstDate: now, // ⛔ tidak bisa tanggal lalu
                    lastDate: DateTime(now.year + 1),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),

              /// JAM MULAI
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  startTime == null
                      ? 'Pilih jam mulai'
                      : startTime!.format(context),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => startTime = picked);
                  }
                },
              ),

              /// DURASI
              Row(
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(width: 12),
                  const Text('Durasi (jam)'),
                  const Spacer(),
                  DropdownButton<int>(
                    value: duration,
                    items: [1, 2, 3, 4]
                        .map(
                          (d) => DropdownMenuItem(
                        value: d,
                        child: Text('$d'),
                      ),
                    )
                        .toList(),
                    onChanged: (v) => setState(() => duration = v!),
                  ),
                ],
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
