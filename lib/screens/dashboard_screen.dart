import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'buku/buku_list_screen.dart';
import 'denda/denda_list_screen.dart';
import 'jenis_buku/jenis_buku_list_screen.dart';
import 'peminjaman/peminjaman_list_screen.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final List<String> _banners = [
    'assets/images/library_bg.jpg',
    'assets/images/library_bg2.jpg',
    'assets/images/library_bg3.jpg',
    'assets/images/library_bg4.jpg',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    await auth.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    if (mounted && auth.status == AuthStatus.authenticated) {
      _usernameController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoggedIn = auth.status == AuthStatus.authenticated;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn ? 'Halo, ${auth.username}' : 'Selamat Datang',
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
              if (isLoggedIn)
                TextButton.icon(
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                    if (mounted) setState(() {});
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
                    return Image.asset(
                      _banners[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppTheme.primary),
                    );
                  },
                ),
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
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Konten utama
          SliverToBoxAdapter(
            child: CustomPaint(
              painter: BgPainter(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: isLoggedIn ? _buildAdminMenu() : _buildLoginForm(auth),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Form login inline
  Widget _buildLoginForm(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Login Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Masuk untuk mengakses menu pengelolaan',
          style: TextStyle(fontSize: 13, color: AppTheme.onSurface),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Error message
                if (auth.errorMessage.isNotEmpty &&
                    auth.status == AuthStatus.error) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      auth.errorMessage,
                      style:
                          const TextStyle(color: AppTheme.error, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Username wajib diisi' : null,
                ),
                const SizedBox(height: 14),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                // Tombol login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        auth.status == AuthStatus.loading ? null : _login,
                    child: auth.status == AuthStatus.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Menu admin setelah login
  Widget _buildAdminMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Kelola data perpustakaan',
          style: TextStyle(fontSize: 13, color: AppTheme.onSurface),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1.05,
          children: [
            _GridMenuCard(
              title: 'Buku',
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF2E7D32),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BukuListScreen()),
              ),
            ),
            _GridMenuCard(
              title: 'Jenis Buku',
              icon: Icons.category_rounded,
              color: const Color(0xFF43A047),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JenisBukuListScreen()),
              ),
            ),
            _GridMenuCard(
              title: 'Penulis',
              icon: Icons.edit_rounded,
              color: const Color(0xFF00897B),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PenulisBukuListScreen()),
              ),
            ),
            _GridMenuCard(
              title: 'Penerbit',
              icon: Icons.business_rounded,
              color: const Color(0xFF558B2F),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PenerbitBukuListScreen()),
              ),
            ),
            _GridMenuCard(
              title: 'Peminjaman',
              icon: Icons.swap_horiz_rounded,
              color: const Color(0xFF1565C0),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PeminjamanListScreen()),
              ),
            ),
            _GridMenuCard(
              title: 'Denda',
              icon: Icons.receipt_long_rounded,
              color: const Color(0xFFC62828),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DendaListScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GridMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GridMenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Ukuran proporsional berdasarkan lebar layar
    final cardPadding = screenWidth * 0.015;
    final containerSize = screenWidth * 0.13;
    final iconSize = screenWidth * 0.085;
    final fontSize = screenWidth * 0.032;
    final borderRadius = screenWidth * 0.045;
    final dekorBesar = screenWidth * 0.13;
    final dekorKecil = screenWidth * 0.065;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withOpacity(0.08),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Dekorasi pojok kanan bawah
            Positioned(
              right: -dekorBesar * 0.17,
              bottom: -dekorBesar * 0.17,
              child: Container(
                width: dekorBesar,
                height: dekorBesar,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.07),
                ),
              ),
            ),
            // Dekorasi pojok kiri atas
            Positioned(
              left: -dekorKecil * 0.2,
              top: -dekorKecil * 0.2,
              child: Container(
                width: dekorKecil,
                height: dekorKecil,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.05),
                ),
              ),
            ),
            // Konten
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: containerSize,
                    height: containerSize,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(containerSize * 0.25),
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
