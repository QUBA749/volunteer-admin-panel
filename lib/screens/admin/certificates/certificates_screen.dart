import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _Phase2Placeholder(
      icon: Icons.card_membership_rounded,
      title: 'Certificates',
    );
  }
}

class _Phase2Placeholder extends StatelessWidget {
  final IconData icon;
  final String title;

  const _Phase2Placeholder({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1929),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: const Color(0xFF7C3AED)),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Coming in Phase 2', style: TextStyle(fontSize: 18, color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}
