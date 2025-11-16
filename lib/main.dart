import 'package:flutter/material.dart';
import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/domain/repositories/auth_repository.dart';
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
        // 1. ApiService (sin dependencias, usa un callback para token)
        Provider<ApiService>(
          create: (_) => ApiService(() => null), // inicialmente sin token
        ),

        // 2. AuthRepository depende de ApiService
        ProxyProvider<ApiService, AuthRepositoryImpl>(
          update: (_, api, __) => AuthRepositoryImpl(api),
        ),

        // 3. AuthProvider depende de AuthRepository
        ChangeNotifierProxyProvider<AuthRepositoryImpl, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthRepositoryImpl>(),
          ),
          update: (context, authRepo, previousProvider) {
            final authProvider = AuthProvider(authRepo);
            authProvider.tryAutoLogin();
            return authProvider;
          },
        ),

        // 4. Actualiza ApiService con token cuando AuthProvider cambia
        ProxyProvider<AuthProvider, ApiService>(
          update: (_, auth, previous) => ApiService(() => auth.token),
        ),

        // 5. ProductRepository depende de ApiService
        ProxyProvider<ApiService, ProductRepositoryImpl>(
          update: (_, api, __) => ProductRepositoryImpl(api),
        ),

        // 6. ProductProvider depende de ProductRepository
        ChangeNotifierProxyProvider<ProductRepositoryImpl, ProductProvider>(
          create: (context) => ProductProvider(
            context.read<ProductRepositoryImpl>(),
          ),
          update: (context, repo, __) => ProductProvider(repo),
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
