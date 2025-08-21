import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getColor() {
      if (isCorrect) return theme.colorScheme.secondary; // صح حسب الثيم
      if (isWrong) return theme.colorScheme.error;        // غلط حسب الثيم
      return theme.cardColor;                             // لون افتراضي حسب الثيم
    }

    IconData? getIcon() {
      if (isCorrect) return Icons.check_circle;
      if (isWrong) return Icons.cancel;
      return null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: getColor().withOpacity(0.2),
          border: Border.all(color: getColor(), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
            ),
            if (getIcon() != null)
              Icon(
                getIcon(),
                color: getColor(),
              ),
          ],
        ),
      ),
    );
  }
}
