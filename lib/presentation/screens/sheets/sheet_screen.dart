// ...existing imports...
import 'package:agri_ledger/core/constants/app_constants.dart';
import 'package:agri_ledger/data/models/daily_record_model.dart';

// ...existing code...

class SheetScreen extends StatefulWidget {
  final String module; // NEW: module id passed to screen
  final String subType; // optional
  // ...existing constructor...
  const SheetScreen({Key? key, required this.module, this.subType = ''})
    : super(key: key);
  // ...existing code...
}

class _SheetScreenState extends State<SheetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _sheets;

  @override
  void initState() {
    super.initState();
    // Build sheet tabs dynamically from ModuleConfig
    final config = ModuleConfig.configs[widget.module];
    _sheets = config != null
        ? List<String>.from(config['sheets'].keys)
        : <String>[];
    _tabController = TabController(length: _sheets.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...existing appBar...
      appBar: AppBar(
        title: Text('${widget.module.toUpperCase()} Sheets'),
        bottom: _sheets.isNotEmpty
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: _sheets.map((s) => Tab(text: s)).toList(),
              )
            : null,
      ),
      body: _sheets.isNotEmpty
          ? TabBarView(
              controller: _tabController,
              children: _sheets.map((sheetKey) {
                final columns =
                    ModuleConfig.configs[widget.module]!['sheets'][sheetKey]
                        as List<dynamic>;
                // ...existing per-sheet form/list builder, use `columns`
                return Center(
                  child: Text('Sheet: $sheetKey'),
                ); // placeholder for concise diff
              }).toList(),
            )
          : Center(child: Text('No sheets configured for ${widget.module}')),
    );
  }

  // ...existing code...
}
