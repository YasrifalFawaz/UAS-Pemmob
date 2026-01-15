import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isLogin = true;

  final namaCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void submit() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      _snack('Email dan password wajib diisi');
      return;
    }

    if (!isLogin && namaCtrl.text.isEmpty) {
      _snack('Nama wajib diisi');
      return;
    }

    if (isLogin) {
      final result =
          await AuthService.login(emailCtrl.text, passCtrl.text);

      if (!mounted) return;

      if (result == null) {
        _snack('Login gagal');
        return;
      }

      if (result['role'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/client',
          arguments: result['id'],
        );
      }
    } else {
      final success = await AuthService.register(
        namaCtrl.text,
        emailCtrl.text,
        passCtrl.text,
      );

      if (!mounted) return;

      if (success) {
        _snack('Register berhasil, silakan login');
        setState(() => isLogin = true);
      } else {
        _snack('Register gagal');
      }
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade600,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),

                  /// JUDUL PROJEK
                  const Text(
                    'MinSoc',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isLogin ? 'Login' : 'Register',
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  if (!isLogin)
                    TextField(
                      controller: namaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                    ),

                  if (!isLogin) const SizedBox(height: 12),

                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submit,
                      child: Text(isLogin ? 'Login' : 'Register'),
                    ),
                  ),

                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? 'Belum punya akun? Register'
                          : 'Sudah punya akun? Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
