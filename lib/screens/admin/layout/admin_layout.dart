import 'package:flutter/material.dart';
import 'sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
