import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SheetTabData {
  final String label;
  final IconData icon;
  const SheetTabData({required this.label, this.icon = Icons.description});
}

class SheetTabs extends StatelessWidget {
  final List<SheetTabData> sheets;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color activeColor;

  const SheetTabs({
    super.key,
    required this.sheets,
    required this.selectedIndex,
    required this.onChanged,
    this.activeColor = const Color(0xFF1B8A3C),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sheets.length,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemBuilder: (_, i) {
          final sheet = sheets[i];
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  sheet.label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : const Color(0xFF64748B), fontFamily: 'Poppins'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
