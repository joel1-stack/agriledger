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
  bool get isManager => read<AuthProvider>().isManager;
  bool get isWorker => read<AuthProvider>().isWorker;
  bool get canAddEdit => read<AuthProvider>().canAddEdit;
  bool get canApprove => read<AuthProvider>().canApprove;
  String get userRole => read<AuthProvider>().userRole;
}
