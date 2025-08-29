import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double total;
  final String label;
  final Color? color;

  const ProgressBar({
    super.key,
    required this.progress,
    required this.total,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress / total).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${progress.toInt()}/${total.toInt()}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? const Color(0xFF1E3A8A),
          ),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
