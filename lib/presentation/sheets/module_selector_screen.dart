import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';

class ModuleSelectorScreen extends StatelessWidget {
  final String? returnRoute;

  const ModuleSelectorScreen({super.key, this.returnRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Select Module'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a module to view', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.textDark)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: ModuleConfig.moduleIds.length,
                itemBuilder: (_, i) {
                  final id = ModuleConfig.moduleIds[i];
                  final mod = ModuleConfig.getModule(id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {
                        'module': id,
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mod.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(mod.icon, color: mod.color, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mod.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.textDark)),
                                  const SizedBox(height: 2),
                                  Text('${mod.subTypes.length} types • ${mod.sheets.length} sheets', style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins')),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
