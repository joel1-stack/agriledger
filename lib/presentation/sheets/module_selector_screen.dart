import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';

const _moduleImages = {
  'poultry': 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&q=80',
  'dairy': 'https://images.unsplash.com/photo-1523475496151-48c8c6e8dd3a?w=400&q=80',
  'crops': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&q=80',
  'livestock': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&q=80',
  'property': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400&q=80',
  'transport': 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400&q=80',
  'cashbook': 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=400&q=80',
  'inventory': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400&q=80',
  'journal': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&q=80',
  'contracts': 'https://images.unsplash.com/photo-1507925921958-8a62f3d1a50d?w=400&q=80',
};

class ModuleSelectorScreen extends StatelessWidget {
  final String? returnRoute;
  const ModuleSelectorScreen({super.key, this.returnRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Select Module', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a farm module', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: ModuleConfig.moduleIds.length,
                itemBuilder: (_, i) {
                  final id = ModuleConfig.moduleIds[i];
                  final mod = ModuleConfig.getModule(id);
                  final imgUrl = _moduleImages[id] ?? '';
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {'module': id}),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: imgUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover) : null,
                        boxShadow: [BoxShadow(color: mod.color.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(10)),
                              child: Icon(mod.icon, color: mod.color, size: 20),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mod.label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))])),
                                const SizedBox(height: 2),
                                Text('${mod.subTypes.length} types', style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Poppins', shadows: const [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))])),
                              ],
                            ),
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
