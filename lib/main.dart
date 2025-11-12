import 'package:flutter/material.dart';
import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/domain/repositories/product_repository.dart';
import 'package:registro_productos/provider/product_provider.dart';
import 'package:registro_productos/screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        // 1. AuthProvider (como lo tenías)
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..tryAutoLogin(),
        ),

        // 2. ProxyProvider para ApiService (depende de AuthProvider)
        //    Crea/actualiza ApiService cada vez que AuthProvider cambia
        ProxyProvider<AuthProvider, ApiService>(
          update: (context, auth, previous) => ApiService(auth),
        ),

        // 3. ProxyProvider para ProductRepository (depende de ApiService)
        ProxyProvider<ApiService, ProductRepository>(
          update: (context, api, previous) => ProductRepositoryImpl(api),
        ),

        // 4. ChangeNotifierProxyProvider para ProductProvider (depende de ProductRepository)
        ChangeNotifierProxyProvider<ProductRepository, ProductProvider>(
          // 'create' solo se llama una vez
          create: (context) => ProductProvider(
            Provider.of<ProductRepository>(context, listen: false),
          ),
          // 'update' se llama cuando ProductRepository (o sus dependencias) cambian
          update: (context, repo, previousProvider) => ProductProvider(repo),
        ),
      ],
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
