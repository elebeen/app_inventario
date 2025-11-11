import 'package:flutter/material.dart';
import 'package:registro_productos/screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..tryAutoLogin(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>(); // re-render cuando cambie
    return MaterialApp(
      title: 'Mi App',
      home: auth.isAuthenticated ? const HomeScreen() : const LoginScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
