import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'jenis_buku/jenis_buku_list_screen.dart';
import 'buku/buku_list_screen.dart';
import 'penerbit_buku/penerbit_buku_list_screen.dart';
import 'penulis_buku/penulis_buku_list_screen.dart';
import '../core/theme/bg_painter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBanner = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<String> _banners = [
    'assets/images/library_bg.jpg',
    'assets/images/library_bg2.jpg',
    'assets/images/library_bg3.jpg',
    'assets/images/library_bg4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthProvider>().username;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // AppBar pinned tipis untuk username + logout
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $username',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const Text(
                  'Sistem Perpustakaan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                icon: const Icon(Icons.logout_rounded,
                    color: Colors.white70, size: 16),
                label: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),

          // Carousel banner
          SliverToBoxAdapter(
            child: Column(
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: _banners.length,
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 600),
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, _) =>
                        setState(() => _currentBanner = index),
                  ),
                  itemBuilder: (context, index, _) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _banners[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppTheme.primary),
                        ),
                      ],
                    );
                  },
                ),
                // Dot indicator
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _banners.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentBanner == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentBanner == i
                            ? AppTheme.primary
                            : AppTheme.primary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Grid menu
          SliverToBoxAdapter(
            child: CustomPaint(
              painter: BgPainter(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _MenuCard(
                      title: 'Jenis Buku',
                      icon: Icons.category_rounded,
                      color: const Color(0xFF43A047),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const JenisBukuListScreen())),
                    ),
                    _MenuCard(
                      title: 'Penulis',
                      icon: Icons.edit_rounded,
                      color: const Color(0xFF00897B),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PenulisBukuListScreen())),
                    ),
                    _MenuCard(
                      title: 'Penerbit',
                      icon: Icons.business_rounded,
                      color: const Color(0xFF558B2F),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PenerbitBukuListScreen())),
                    ),
                    _MenuCard(
                      title: 'Buku',
                      icon: Icons.menu_book_rounded,
                      color: const Color(0xFF2E7D32),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BukuListScreen())),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 34),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.onBackground,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
