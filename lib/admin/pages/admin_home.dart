import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'booking_list_page.dart';
// Pastikan path import ini sesuai dengan lokasi file login Anda
// import '../../services/login_register_page.dart'; 

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _index = 0;

  // Hapus 'const' agar tidak menyebabkan error "Not a constant expression"
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardPage(),
      const BookingListPage(),
    ];
  }

  // Fungsi logout untuk kembali ke halaman login (rute '/')
  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // Mengarahkan ke rute login awal
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: logout,
          )
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Colors.blue, 
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Booking',
          ),
        ],
      ),
    );
  }
}