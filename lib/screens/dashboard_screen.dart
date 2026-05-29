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
    if (!mounted) return;
    if (auth.status == AuthStatus.authenticated) {
      _usernameController.clear();
      _passwordController.clear();
      _showSuccessDialog(auth.username);
    } else if (auth.status == AuthStatus.error) {
      _showErrorDialog(auth.errorMessage);
    }
  }

  void _showSuccessDialog(String username) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF2E7D32), size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Login Berhasil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppTheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selamat datang, $username',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppTheme.onSurface),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Lanjutkan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Auto-close setelah 2.5 detik
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.cancel_rounded, color: AppTheme.error, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Login Gagal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppTheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Username atau password salah.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppTheme.onSurface),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary,
                    AppTheme.primary.withOpacity(0.85),
                    const Color(0xFF1B5E20),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_library_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn ? 'Halo, ${auth.username}' : 'Selamat Datang',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Text(
                      'Sistem Perpustakaan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              if (isLoggedIn)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.logout_rounded,
                        color: Colors.white, size: 14),
                    label: const Text(
                      'Keluar',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),

          // Carousel banner
          SliverToBoxAdapter(
            child: Stack(
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: _banners.length,
                  options: CarouselOptions(
                    height: 220,
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
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppTheme.primary,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.white54, size: 48),
                          ),
                        ),
                        // Gradient overlay bawah
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.35),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Dots indicator overlay (glass style)
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _banners.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentBanner == i ? 22 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _currentBanner == i
                              ? Colors.white
                              : Colors.white.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: _currentBanner == i
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
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
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary,
                    AppTheme.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Login Admin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.onBackground,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Akses Terbatas',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Masuk untuk mengakses menu pengelolaan',
                  style: TextStyle(fontSize: 12, color: AppTheme.onSurface),
                ),
              ],
            ),
          ],
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
                      'Username atau password salah.',
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
