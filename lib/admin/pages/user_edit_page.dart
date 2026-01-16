import 'package:flutter/material.dart';
import '../services/user_service.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController namaCtrl;
  late TextEditingController emailCtrl;
  late String role;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.user['nama']);
    emailCtrl = TextEditingController(text: widget.user['email']);
    role = widget.user['role']; // client / admin
  }

  Future<void> submit() async {
    if (namaCtrl.text.isEmpty || emailCtrl.text.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    setState(() => loading = true);

    final success = await AdminUserService.update(
      widget.user['id'],
      namaCtrl.text,
      emailCtrl.text,
      role,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true); // kembali & refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal update user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 12),

            /// ROLE
            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(
                  value: 'client',
                  child: Text('Client'),
                ),
                DropdownMenuItem(
                  value: 'admin',
                  child: Text('Admin'),
                ),
              ],
              onChanged: (v) {
                if (v != null) {
                  setState(() => role = v);
                }
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SIMPAN PERUBAHAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
