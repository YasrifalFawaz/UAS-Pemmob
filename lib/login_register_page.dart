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
  bool _obscurePassword = true;

  void submit() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      _snack('Email dan password wajib diisi', Colors.red);
      return;
    }

    if (!isLogin && namaCtrl.text.isEmpty) {
      _snack('Nama wajib diisi', Colors.red);
      return;
    }

    if (isLogin) {
      final result = await AuthService.login(emailCtrl.text, passCtrl.text);

      if (!mounted) return;

      if (result == null) {
        _snack('Login gagal', Colors.red);
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
      // PERBAIKAN: Register sekarang mengembalikan data user
      final result = await AuthService.register(
        namaCtrl.text,
        emailCtrl.text,
        passCtrl.text,
      );

      if (!mounted) return;

      if (result != null) {
        _snack('Register berhasil! Selamat datang 🎉', Colors.green);
        
        // Auto-login setelah register berhasil
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
        _snack('Register gagal', Colors.red);
      }
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1B5E20), // Dark green
              const Color(0xFF2E7D32), // Medium green
              const Color(0xFF43A047), // Light green
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo dan header dengan efek stadium
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        size: 80,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title dengan gaya modern
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Colors.white70],
                      ).createShader(bounds),
                      child: const Text(
                        'MinSoc',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mini Soccer Management',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Card form dengan design modern
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          children: [
                            // Tab header dengan design field
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1B5E20),
                                    Color(0xFF2E7D32),
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTabButton(
                                      'Login',
                                      isLogin,
                                      () => setState(() => isLogin = true),
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildTabButton(
                                      'Register',
                                      !isLogin,
                                      () => setState(() => isLogin = false),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Form fields
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  // Nama field (hanya untuk register)
                                  if (!isLogin) ...[
                                    _buildTextField(
                                      controller: namaCtrl,
                                      label: 'Nama Lengkap',
                                      icon: Icons.person,
                                      hint: 'Masukkan nama lengkap',
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Email field
                                  _buildTextField(
                                    controller: emailCtrl,
                                    label: 'Email',
                                    icon: Icons.email,
                                    hint: 'Masukkan email',
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),

                                  // Password field
                                  _buildTextField(
                                    controller: passCtrl,
                                    label: 'Password',
                                    icon: Icons.lock,
                                    hint: 'Masukkan password',
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF1B5E20),
                                      ),
                                      onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Submit button dengan design modern
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1B5E20),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 8,
                                        shadowColor:
                                            const Color(0xFF1B5E20).withOpacity(0.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            isLogin ? 'Login' : 'Register',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.arrow_forward, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Toggle button
                                  TextButton(
                                    onPressed: () =>
                                        setState(() => isLogin = !isLogin),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF1B5E20),
                                    ),
                                    child: Text(
                                      isLogin
                                          ? 'Belum punya akun? Register sekarang'
                                          : 'Sudah punya akun? Login di sini',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer text
                    Text(
                      '⚽ Kelola lapangan mini soccer Anda dengan mudah',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF1B5E20) : Colors.white70,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1B5E20)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }
}