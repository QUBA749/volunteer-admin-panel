import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      width: 260,
      color: const Color(0xFF1A1929),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(Icons.volunteer_activism_rounded, color: Color(0xFF7C3AED), size: 32),
                SizedBox(width: 12),
                Text('VolunteerHub', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _NavItem(icon: Icons.dashboard_rounded, title: 'Dashboard', route: '/dashboard', currentRoute: currentRoute),
                _NavItem(icon: Icons.people_rounded, title: 'Volunteers', route: '/volunteers', currentRoute: currentRoute),
                _NavItem(icon: Icons.event_rounded, title: 'Events', route: '/events', currentRoute: currentRoute),
                _NavItem(icon: Icons.fact_check_rounded, title: 'Attendance', route: '/attendance', currentRoute: currentRoute),
                _NavItem(icon: Icons.task_alt_rounded, title: 'Tasks', route: '/tasks', currentRoute: currentRoute),
                _NavItem(icon: Icons.card_membership_rounded, title: 'Certificates', route: '/certificates', currentRoute: currentRoute),
                _NavItem(icon: Icons.smart_toy_rounded, title: 'Chatbot', route: '/chatbot', currentRoute: currentRoute),
                const Divider(color: Colors.white10),
                _NavItem(icon: Icons.settings_rounded, title: 'Settings', route: '/settings', currentRoute: currentRoute),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.white70),
                  title: const Text('Logout', style: TextStyle(color: Colors.white70)),
                  onTap: () {
                    AuthService().logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF7C3AED),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AuthService().currentCoordinator?.fullName ?? 'Admin User', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(AuthService().currentCoordinator?.role.toUpperCase() ?? 'ADMIN', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String route;
  final String? currentRoute;

  const _NavItem({required this.icon, required this.title, required this.route, this.currentRoute});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.currentRoute?.startsWith(widget.route) ?? false;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7C3AED) : (_isHovered ? Colors.white.withOpacity(0.05) : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(widget.icon, color: isActive ? Colors.white : Colors.white70),
          title: Text(widget.title, style: TextStyle(color: isActive ? Colors.white : Colors.white70)),
          onTap: () {
            if (!isActive) Navigator.pushReplacementNamed(context, widget.route);
          },
        ),
      ),
    );
  }
}
