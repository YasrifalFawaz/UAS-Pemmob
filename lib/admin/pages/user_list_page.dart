import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'user_create_page.dart';
import 'user_edit_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<dynamic>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = AdminUserService.getAll();
  }

  void refresh() {
    setState(() {
      futureUsers = AdminUserService.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateUserPage()),
              );
              refresh();
            },
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('User kosong'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              final isAdmin = u['role'] == 'admin';

              return Card(
                child: ListTile(
                  title: Text(u['nama']),
                  subtitle: Text('${u['email']} • ${u['role']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditUserPage(user: u),
                            ),
                          );
                          refresh();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: isAdmin ? Colors.grey : Colors.red,
                        ),
                        onPressed: isAdmin
                            ? null
                            : () async {
                                await AdminUserService.delete(u['id']);
                                refresh();
                              },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
