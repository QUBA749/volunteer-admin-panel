import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().init();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolunteerHub Admin',
      theme: appTheme,
      initialRoute: AuthService().isAuthenticated ? '/dashboard' : '/login',
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
