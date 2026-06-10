class ChartOfAccount {
  final String id;
  final String code;
  final String name;
  final String type;
  final String? parentId;
  final double balance;
  final bool isActive;

  ChartOfAccount({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    this.parentId,
    this.balance = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
    'code': code,
    'name': name,
    'type': type,
    'parentId': parentId,
    'balance': balance,
    'isActive': isActive,
  };

  factory ChartOfAccount.fromMap(String id, Map<String, dynamic> m) => ChartOfAccount(
    id: id,
    code: m['code'] ?? '',
    name: m['name'] ?? '',
    type: m['type'] ?? 'asset',
    parentId: m['parentId'],
    balance: (m['balance'] ?? 0).toDouble(),
    isActive: m['isActive'] ?? true,
  );
}
