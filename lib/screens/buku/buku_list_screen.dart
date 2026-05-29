import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../models/buku_model.dart';
import '../../providers/buku_provider.dart';
import 'buku_detail_screen.dart';

class BukuListScreen extends StatefulWidget {
  const BukuListScreen({super.key});

  @override
  State<BukuListScreen> createState() => _BukuListScreenState();
}

class _BukuListScreenState extends State<BukuListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BukuProvider>().fetchAll();
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Daftar Buku',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BgPainter())),
          Column(
            children: [
              // Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari judul, ISBN, atau rak...',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppTheme.onSurface.withOpacity(0.6)),
                      prefixIcon:
                          Icon(Icons.search_rounded, color: AppTheme.primary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded,
                                  color: AppTheme.onSurface, size: 18),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              // List
              Expanded(
                child: Consumer<BukuProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.error != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: AppTheme.error, size: 48),
                              const SizedBox(height: 12),
                              Text(provider.error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppTheme.error)),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => provider.fetchAll(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Filter realtime
                    final filtered = _searchQuery.isEmpty
                        ? provider.list
                        : provider.list.where((b) {
                            return b.judulBuku
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                b.isbn.toLowerCase().contains(_searchQuery) ||
                                b.rakBuku.toLowerCase().contains(_searchQuery);
                          }).toList();

                    if (provider.list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book_rounded,
                                size: 64,
                                color: AppTheme.primary.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            Text('Belum ada data buku',
                                style: TextStyle(
                                    color: AppTheme.onSurface, fontSize: 15)),
                          ],
                        ),
                      );
                    }

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 56,
                                color: AppTheme.primary.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada hasil untuk\n"$_searchQuery"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppTheme.onSurface, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _BukuCard(
                          buku: item,
                          searchQuery: _searchQuery,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BukuDetailScreen(buku: item)),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BukuCard extends StatelessWidget {
  final Buku buku;
  final VoidCallback onTap;
  final String searchQuery;

  const _BukuCard({
    required this.buku,
    required this.onTap,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.menu_book_rounded,
                    color: AppTheme.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HighlightText(
                      text: buku.judulBuku,
                      query: searchQuery,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.onBackground),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text('ISBN: ${buku.isbn}',
                        style:
                            TextStyle(fontSize: 12, color: AppTheme.onSurface)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Badge(
                          icon: Icons.inventory_2_rounded,
                          label: 'Stok: ${buku.stokBuku}',
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        _Badge(
                          icon: Icons.shelves,
                          label: 'Rak: ${buku.rakBuku}',
                          color: const Color(0xFF00897B),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppTheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final int maxLines;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text,
          style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }
    final lowerText = text.toLowerCase();
    final matchIndex = lowerText.indexOf(query);
    if (matchIndex == -1) {
      return Text(text,
          style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, matchIndex)),
          TextSpan(
            text: text.substring(matchIndex, matchIndex + query.length),
            style: style.copyWith(
              backgroundColor: AppTheme.primary.withOpacity(0.2),
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text.substring(matchIndex + query.length)),
        ],
      ),
    );
  }
}
