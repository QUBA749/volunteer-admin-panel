import 'package:flutter/material.dart';
import '../config/theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    Color color;
    if (s == 'active' || s == 'present' || s == 'upcoming') {
      color = StatusColors.green;
    } else if (s == 'inactive' || s == 'late' || s == 'ongoing') {
      color = StatusColors.yellow;
    } else {
      color = StatusColors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
