import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/select_store_screen.dart';
import 'screens/employee/employee_home_screen.dart';
import 'provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider())
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Gestión de Productos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      // home: const LoginScreen(),
      home: auth.isAuthenticated
         ? const EmployeeHomeScreen() 
         : const LoginScreen(),
      routes: {
        '/home': (context) => const EmployeeHomeScreen(),
        '/admin_store': (context) => const SelectStoreScreen(),
      },
    );
  }
}
