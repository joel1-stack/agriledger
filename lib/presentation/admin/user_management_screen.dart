import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth/auth_provider.dart';
import '../../data/models/user_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('User Management', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
        actions: [
          IconButton(icon: const Icon(Icons.person_add_rounded), onPressed: () => _showAddUserDialog(context)),
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
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2)),
                suffixIcon: _search.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); }) : null,
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: _usersStream(),
              builder: (_, snap) {
                if (snap.hasError) return Center(child: Text('Error: ${snap.error}', style: const TextStyle(color: Color(0xFFEF4444), fontFamily: 'Poppins')));
                final users = snap.data ?? [];
                final filtered = users.where((u) => _search.isEmpty || u.name.toLowerCase().contains(_search) || u.email.toLowerCase().contains(_search)).toList();
                if (filtered.isEmpty) {
                  return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.people_outline_rounded, size: 64, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8), Text('No users found', style: TextStyle(fontSize: 15, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                  ]));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _UserCard(user: filtered[i], onTap: () => _showEditUserDialog(context, filtered[i])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<UserModel>> _usersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => UserModel.fromFirestore(d)).toList());
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    String role = user.role;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${user.name}'),
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(user.id).update({
                'name': nameCtrl.text,
                'role': role,
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _UserCard({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final roleColors = {
      'superAdmin': const Color(0xFF8B5CF6),
      'viewAdmin': const Color(0xFF0EA5E9),
      'general': const Color(0xFF10B981),
    };
    final color = roleColors[user.role] ?? const Color(0xFF10B981);
    final roleLabel = user.role == 'superAdmin' ? 'Super Admin' : (user.role == 'viewAdmin' ? 'Admin' : 'General User');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Text(user.name[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
        ),
        title: Text(user.name, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A))),
        subtitle: Text(user.email, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF64748B))),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(roleLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
        ),
        onTap: onTap,
      ),
    );
  }
}
