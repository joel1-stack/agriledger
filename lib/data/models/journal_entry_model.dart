class JournalEntry {
  final String id;
  final String date;
  final String reference;
  final String description;
  final List<Map<String, dynamic>> entries;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;
  final String period;
  final String recordedBy;
  final String status;

  JournalEntry({
    required this.id,
    required this.date,
    this.reference = '',
    this.description = '',
    this.entries = const [],
    this.totalDebit = 0,
    this.totalCredit = 0,
    this.isBalanced = true,
    this.period = '',
    required this.recordedBy,
    this.status = 'posted',
  });

  Map<String, dynamic> toMap() => {
    'date': date,
    'reference': reference,
    'description': description,
    'entries': entries,
    'totalDebit': totalDebit,
    'totalCredit': totalCredit,
    'isBalanced': isBalanced,
    'period': period,
    'recordedBy': recordedBy,
    'status': status,
  };

  factory JournalEntry.fromMap(String id, Map<String, dynamic> m) => JournalEntry(
    id: id,
    date: m['date'] ?? '',
    reference: m['reference'] ?? '',
    description: m['description'] ?? '',
    entries: List<Map<String, dynamic>>.from(m['entries'] ?? []),
    totalDebit: (m['totalDebit'] ?? 0).toDouble(),
    totalCredit: (m['totalCredit'] ?? 0).toDouble(),
    isBalanced: m['isBalanced'] ?? true,
    period: m['period'] ?? '',
    recordedBy: m['recordedBy'] ?? '',
    status: m['status'] ?? 'posted',
  );
}
