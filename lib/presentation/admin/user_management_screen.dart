import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth/auth_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _mockUsers = [
    {'name': 'Farm Owner', 'email': 'owner@farm.com', 'role': 'superAdmin'},
    {'name': 'Admin Alice', 'email': 'alice@farm.com', 'role': 'viewAdmin'},
    {'name': 'General John', 'email': 'john@farm.com', 'role': 'general'},
    {'name': 'General Jane', 'email': 'jane@farm.com', 'role': 'general'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: () => _showAddUserDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); })
                    : null,
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mockUsers.length,
              itemBuilder: (_, i) {
                final u = _mockUsers[i];
                if (_search.isNotEmpty && !u['name']!.toLowerCase().contains(_search) && !u['email']!.toLowerCase().contains(_search)) {
                  return const SizedBox.shrink();
                }
                return _UserCard(
                  name: u['name']!,
                  email: u['email']!,
                  role: u['role']!,
                  onTap: () => _showEditUserDialog(context, u),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    String role = 'general';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', isDense: true)),
            const SizedBox(height: 8),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email', isDense: true)),
            const SizedBox(height: 8),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password', isDense: true), obscureText: true),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Role', isDense: true),
              items: ['superAdmin', 'viewAdmin', 'general'].map((r) {
                String label = r == 'superAdmin' ? 'Super Admin' : (r == 'viewAdmin' ? 'Admin' : 'General User');
                return DropdownMenuItem(value: r, child: Text(label));
              }).toList(),
              onChanged: (v) => role = v ?? 'general',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              await auth.signUp(emailCtrl.text, passCtrl.text, nameCtrl.text, role: role);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, Map<String, String> user) {
    final nameCtrl = TextEditingController(text: user['name']);
    String role = user['role']!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit ${user['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', isDense: true)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Role', isDense: true),
              items: ['superAdmin', 'viewAdmin', 'general'].map((r) {
                String label = r == 'superAdmin' ? 'Super Admin' : (r == 'viewAdmin' ? 'Admin' : 'General User');
                return DropdownMenuItem(value: r, child: Text(label));
              }).toList(),
              onChanged: (v) => role = v ?? role,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String name, email, role;
  final VoidCallback onTap;

  const _UserCard({required this.name, required this.email, required this.role, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final roleColors = {
      'superAdmin': AppColors.accentPurple,
      'viewAdmin': const Color(0xFF0EA5E9),
      'general': AppColors.primaryGreen,
    };
    final color = roleColors[role] ?? AppColors.primaryGreen;
    final roleLabel = role == 'superAdmin' ? 'Super Admin' : (role == 'viewAdmin' ? 'Admin' : 'General User');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Text(name[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.w700, color: color)),
        ),
        title: Text(name, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(email, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: Text(
            roleLabel,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color, fontFamily: 'Poppins'),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
