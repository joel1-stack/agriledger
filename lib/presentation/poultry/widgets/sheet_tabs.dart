import 'package:flutter/material.dart';
import '../../../config/sheet_config.dart';
import '../../../core/theme/app_theme.dart';

class SheetTabs extends StatelessWidget {
  final List<SheetConfig> sheets;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SheetTabs({
    super.key,
    required this.sheets,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.mintGreen,
        borderRadius: BorderRadius.circular(12),
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    sheet.icon,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.textMedium,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sheet.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textMedium,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
