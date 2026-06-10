import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessUnit {
  final String id;
  final String name;
  final List<String> modules;
  final String currency;
  final String fiscalYearStart;
  final String ownerId;

  BusinessUnit({
    required this.id,
    required this.name,
    this.modules = const [],
    this.currency = 'KES',
    this.fiscalYearStart = '2026-01-01',
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'modules': modules,
    'currency': currency,
    'fiscalYearStart': fiscalYearStart,
    'ownerId': ownerId,
  };

  factory BusinessUnit.fromMap(String id, Map<String, dynamic> m) => BusinessUnit(
    id: id,
    name: m['name'] ?? '',
    modules: List<String>.from(m['modules'] ?? []),
    currency: m['currency'] ?? 'KES',
    fiscalYearStart: m['fiscalYearStart'] ?? '2026-01-01',
    ownerId: m['ownerId'] ?? '',
  );
}
