import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'buku/buku_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.watch<AuthProvider>().status == AuthStatus.authenticated;

    // Kalau sudah login, hanya tampilkan DashboardScreen tanpa bottom nav
    if (isLoggedIn) {
      return const DashboardScreen();
    }

    // Guest mode — 2 tab saja
    const List<_NavItem> navItems = [
      _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
      _NavItem(icon: Icons.menu_book_rounded, label: 'Buku'),
    ];

    const List<Widget> screens = [
      DashboardScreen(),
      BukuListScreen(),
    ];

    final safeIndex = _currentIndex < navItems.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (i) {
                final selected = safeIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primary.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          navItems[i].icon,
                          color:
                              selected ? AppTheme.primary : AppTheme.onSurface,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          navItems[i].label,
                          style: TextStyle(
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.onSurface,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
