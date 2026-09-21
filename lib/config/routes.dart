import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/admin/layout/admin_layout.dart';
import '../screens/admin/dashboard/dashboard_screen.dart';
import '../screens/admin/volunteers/volunteers_screen.dart';
import '../screens/admin/volunteers/volunteer_detail_screen.dart';
import '../screens/admin/events/events_screen.dart';
import '../screens/admin/attendance/attendance_screen.dart';
import '../screens/admin/tasks/tasks_screen.dart';
import '../screens/admin/certificates/certificates_screen.dart';
import '../screens/admin/chatbot/chatbot_screen.dart';
import '../services/auth_service.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name != '/login' && settings.name != '/forgot-password' && !AuthService().isAuthenticated) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: DashboardScreen()));
      case '/volunteers':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: VolunteersScreen()));
      case '/volunteers/detail':
        final id = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => AdminLayout(child: VolunteerDetailScreen(volunteerId: id ?? '')));
      case '/events':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: EventsScreen()));
      case '/attendance':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: AttendanceScreen()));
      case '/tasks':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: TasksScreen()));
      case '/certificates':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: CertificatesScreen()));
      case '/chatbot':
        return MaterialPageRoute(builder: (_) => const AdminLayout(child: ChatbotScreen()));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
