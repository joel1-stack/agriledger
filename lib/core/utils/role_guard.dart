import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth/auth_provider.dart';

class RoleGuard extends StatelessWidget {
  final List<String> allowedRoles;
  final Widget child;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().userRole;
    if (allowedRoles.contains(role)) return child;
    return const SizedBox.shrink();
  }
}

class RoleBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, String role) builder;

  const RoleBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().userRole;
    return builder(context, role);
  }
}

extension RoleContext on BuildContext {
  bool get isSuperAdmin => read<AuthProvider>().isSuperAdmin;
  bool get isViewAdmin => read<AuthProvider>().isViewAdmin;
  bool get isGeneralUser => read<AuthProvider>().isGeneralUser;
  bool get isManager => isViewAdmin || isSuperAdmin;
  bool get canAddEdit => read<AuthProvider>().canAddEdit;
  bool get canApprove => read<AuthProvider>().canApprove;
  bool get canDelete => read<AuthProvider>().canDelete;
  String get userRole => read<AuthProvider>().userRole;

  bool canEditRecord(String recordedBy, DateTime createdAt, String status) {
    final role = userRole;
    if (role == 'superAdmin') return true;
    if (role == 'viewAdmin') return true;
    if (role == 'general') {
      final isOwner = recordedBy == read<AuthProvider>().userId;
      final within24h = DateTime.now().difference(createdAt).inHours < 24;
      final isPending = status == 'pending';
      return isOwner && within24h && isPending;
    }
    return false;
  }
}
