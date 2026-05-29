import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Large circle top-right
    paintFill.color = AppTheme.primary.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width + 40, -40), 180, paintFill);

    paintStroke.color = AppTheme.primary.withOpacity(0.12);
    canvas.drawCircle(Offset(size.width + 40, -40), 220, paintStroke);
    canvas.drawCircle(Offset(size.width + 40, -40), 260, paintStroke);

    // Medium circle bottom-left
    paintFill.color = AppTheme.primaryLight.withOpacity(0.07);
    canvas.drawCircle(Offset(-60, size.height + 20), 160, paintFill);

    paintStroke.color = AppTheme.primaryLight.withOpacity(0.1);
    canvas.drawCircle(Offset(-60, size.height + 20), 200, paintStroke);
    canvas.drawCircle(Offset(-60, size.height + 20), 240, paintStroke);

    // Leaf shape top-left
    _drawLeaf(
        canvas, Offset(30, 80), 50, -0.3, AppTheme.primary.withOpacity(0.1));
    _drawLeaf(canvas, Offset(60, 50), 40, 0.4,
        AppTheme.primaryLight.withOpacity(0.08));

    // Leaf shape bottom-right
    _drawLeaf(canvas, Offset(size.width - 30, size.height - 80), 60,
        math.pi + 0.3, AppTheme.primary.withOpacity(0.1));
    _drawLeaf(canvas, Offset(size.width - 60, size.height - 50), 45,
        math.pi - 0.4, AppTheme.primaryLight.withOpacity(0.08));

    // Scattered small dots
    final dots = [
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.82, size.height * 0.4),
      Offset(size.width * 0.25, size.height * 0.75),
      Offset(size.width * 0.7, size.height * 0.85),
      Offset(size.width * 0.5, size.height * 0.12),
      Offset(size.width * 0.9, size.height * 0.7),
    ];
    paintFill.color = AppTheme.primary.withOpacity(0.15);
    for (final dot in dots) {
      canvas.drawCircle(dot, 4, paintFill);
    }

    // Thin diagonal lines
    paintStroke.color = AppTheme.primary.withOpacity(0.05);
    paintStroke.strokeWidth = 1;
    for (int i = 0; i < 6; i++) {
      final x = size.width * 0.1 * (i + 1);
      canvas.drawLine(
        Offset(x - 40, 0),
        Offset(x + 40, size.height),
        paintStroke,
      );
    }
  }

  void _drawLeaf(
      Canvas canvas, Offset center, double size, double angle, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, -size);
    path.cubicTo(size * 0.6, -size * 0.6, size * 0.6, size * 0.6, 0, size);
    path.cubicTo(-size * 0.6, size * 0.6, -size * 0.6, -size * 0.6, 0, -size);
    path.close();

    canvas.drawPath(path, paint);

    // Leaf vein
    final veinPaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, -size * 0.8), Offset(0, size * 0.8), veinPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Login Screen ───────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    final success = await provider.login(
        _usernameCtr.text.trim(), _passwordCtr.text.trim());
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background painter
          Positioned.fill(
            child: CustomPaint(painter: BgPainter()),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height - MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Icon
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryLight,
                                AppTheme.primaryDark,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'Selamat Datang',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.onBackground,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Masuk ke Sistem Perpustakaan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.onSurface,
                            ),
                      ),

                      const Spacer(flex: 1),

                      // Card form
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _usernameCtr,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon:
                                      Icon(Icons.person_outline_rounded),
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Wajib diisi'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordCtr,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Wajib diisi'
                                    : null,
                              ),
                              const SizedBox(height: 24),
                              Consumer<AuthProvider>(
                                builder: (context, provider, _) {
                                  if (provider.status == AuthStatus.loading) {
                                    return const SizedBox(
                                      height: 52,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                  return Column(
                                    children: [
                                      if (provider.status == AuthStatus.error)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                          decoration: BoxDecoration(
                                            color:
                                                AppTheme.error.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: AppTheme.error
                                                    .withOpacity(0.3)),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.error_outline,
                                                  color: AppTheme.error,
                                                  size: 18),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  provider.errorMessage,
                                                  style: TextStyle(
                                                      color: AppTheme.error,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ElevatedButton(
                                        onPressed: _login,
                                        child: const Text('Masuk'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      Center(
                        child: Text(
                          'Sistem Manajemen Perpustakaan',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.onSurface,
                                    fontSize: 12,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
