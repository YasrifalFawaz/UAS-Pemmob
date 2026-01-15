import 'package:flutter/material.dart';
import 'login_register_page.dart';
import 'client/pages/client_home.dart';
import 'admin/pages/admin_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginRegisterPage(),
        '/admin': (context) => const AdminHome(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/client') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => ClientHome(userId: userId),
          );
        }
        return null;
      },
    );
  }
}
