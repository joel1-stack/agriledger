// ...existing imports...
import 'package:agri_ledger/data/models/daily_record_model.dart';

// ...existing code...

Widget _buildApprovalCard(DailyRecord record) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Text(record.module.substring(0, 1).toUpperCase()),
      ),
      title: Text('${record.sheetType} — ${record.unitId}'),
      subtitle: Text('By ${record.recordedByName} • ${record.subType}'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Module badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              record.module.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          SizedBox(height: 6),
          Text(
            record.status.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        // ...existing open approval details...
      },
    ),
  );
}

// ...existing code where list is built...
