// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/buku_provider.dart';
import 'providers/denda_provider.dart';
import 'providers/peminjaman_provider.dart';
import 'providers/penerbit_buku_provider.dart';
import 'screens/home_screen.dart';
import 'providers/jenis_buku_provider.dart';
import 'providers/penulis_buku_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BukuProvider()),
        ChangeNotifierProvider(create: (_) => JenisBukuProvider()),
        ChangeNotifierProvider(create: (_) => PenulisBukuProvider()),
        ChangeNotifierProvider(create: (_) => PenerbitBukuProvider()),
        ChangeNotifierProvider(create: (_) => PeminjamanProvider()),
        ChangeNotifierProvider(create: (_) => DendaProvider()),
      ],
      child: MaterialApp(
        title: 'Perpustakaan',
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/home': (_) => const HomeScreen(),
        },
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Cek token di background, tapi tidak block tampilan
    Future.microtask(() => context.read<AuthProvider>().checkLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    // Langsung tampilkan HomeScreen, auth status akan di-handle per fitur
    return const HomeScreen();
  }
}
