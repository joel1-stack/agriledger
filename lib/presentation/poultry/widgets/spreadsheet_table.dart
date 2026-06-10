import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'status_badge.dart';

class SpreadsheetTable extends StatelessWidget {
  final List<dynamic> columns;
  final List<Map<String, dynamic>> rows;
  final void Function(Map<String, dynamic> row)? onTapRow;
  final void Function(Map<String, dynamic> row)? onApprove;
  final void Function(Map<String, dynamic> row)? onReject;
  final bool showApproval;
  final bool showStatus;

  const SpreadsheetTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onTapRow,
    this.onApprove,
    this.onReject,
    this.showApproval = false,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final colLabels = columns.map((c) {
      if (c is String) return c;
      return c.label ?? '';
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        headingRowHeight: 44,
        dataRowMinHeight: 44,
        dataRowMaxHeight: 52,
        headingRowColor: WidgetStateProperty.all(AppColors.primaryGreen.withValues(alpha: 0.08)),
        columns: [
          ...colLabels.map((c) => DataColumn(
                label: Text(c, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark, fontFamily: 'Poppins')),
              )),
          if (showStatus)
            const DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark, fontFamily: 'Poppins'))),
          if (showApproval) const DataColumn(label: Text('Action', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        ],
        rows: rows.asMap().entries.map((entry) {
          final row = entry.value;
          final status = row['status'] ?? 'pending';
          return DataRow(
            color: WidgetStateProperty.resolveWith((_) {
              if (status == 'approved') return AppColors.mintGreen.withValues(alpha: 0.3);
              if (status == 'rejected') return AppColors.accentRed.withValues(alpha: 0.06);
              return null;
            }),
            onSelectChanged: onTapRow != null ? (_) => onTapRow!(row) : null,
            cells: [
              ...colLabels.map((c) {
                final key = c.toLowerCase();
                final val = row[key]?.toString() ?? row[c]?.toString() ?? '';
                return DataCell(
                  Text(val, style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontFamily: 'Poppins')),
                );
              }),
              if (showStatus)
                DataCell(
                  row['recordedBy'] != null
                      ? StatusBadge(status: status)
                      : const SizedBox.shrink(),
                ),
              if (showApproval)
                DataCell(
                  status == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ActionBtn(Icons.check_circle, AppColors.primaryGreen, () => onApprove?.call(row)),
                            const SizedBox(width: 4),
                            _ActionBtn(Icons.cancel, AppColors.accentRed, () => onReject?.call(row)),
                          ],
                        )
                      : Text(
                          status == 'approved' ? 'Approved' : 'Rejected',
                          style: TextStyle(fontSize: 11, color: status == 'approved' ? AppColors.primaryGreen : AppColors.accentRed, fontFamily: 'Poppins'),
                        ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
