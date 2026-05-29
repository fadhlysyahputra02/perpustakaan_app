import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../models/buku_model.dart';

class BukuDetailScreen extends StatelessWidget {
  final Buku buku;
  const BukuDetailScreen({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(buku.judulBuku,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BgPainter())),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryLight, AppTheme.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.menu_book_rounded,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(buku.judulBuku,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('ISBN: ${buku.isbn}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Stat cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                          icon: Icons.inventory_2_rounded,
                          label: 'Stok',
                          value: buku.stokBuku.toString(),
                          color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                          icon: Icons.shelves,
                          label: 'Rak',
                          value: buku.rakBuku,
                          color: const Color(0xFF00897B)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                          icon: Icons.check_circle_rounded,
                          label: 'Kondisi',
                          value: buku.kondisiBuku,
                          color: const Color(0xFF558B2F)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Detail card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informasi Detail',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppTheme.onBackground)),
                      const SizedBox(height: 14),
                      _InfoRow(
                          icon: Icons.calendar_today_rounded,
                          label: 'Tahun Terbit',
                          value: buku.tahunTerbit),
                      _InfoRow(
                          icon: Icons.numbers_rounded,
                          label: 'ISBN',
                          value: buku.isbn),
                      _InfoRow(
                          icon: Icons.category_rounded,
                          label: 'ID Kategori',
                          value: buku.idKategoriBuku),
                      _InfoRow(
                          icon: Icons.person_rounded,
                          label: 'ID Penulis',
                          value: buku.idPenulisBuku),
                      _InfoRow(
                          icon: Icons.business_rounded,
                          label: 'ID Penerbit',
                          value: buku.idPenerbitBuku),
                      _InfoRow(
                          icon: Icons.description_rounded,
                          label: 'Deskripsi',
                          value: buku.deskripsiBuku),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value.isEmpty ? '-' : value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(color: AppTheme.onSurface, fontSize: 11)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: AppTheme.onSurface, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value.isEmpty ? '-' : value,
                    style: const TextStyle(
                        color: AppTheme.onBackground,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
