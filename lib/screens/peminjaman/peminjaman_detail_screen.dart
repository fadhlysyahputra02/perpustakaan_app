import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../providers/peminjaman_provider.dart';

class PeminjamanDetailScreen extends StatefulWidget {
  final String id;
  const PeminjamanDetailScreen({super.key, required this.id});

  @override
  State<PeminjamanDetailScreen> createState() => _PeminjamanDetailScreenState();
}

class _PeminjamanDetailScreenState extends State<PeminjamanDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PeminjamanProvider>().fetchDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Detail Peminjaman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BgPainter())),
          Consumer<PeminjamanProvider>(
            builder: (context, provider, _) {
              if (provider.isDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.detailError != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: AppTheme.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          provider.detailError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => provider.fetchDetail(widget.id),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final d = provider.detail;
              if (d == null) {
                return const Center(
                  child: Text('Data tidak ditemukan.'),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoCard(
                      title: 'Informasi Peminjaman',
                      icon: Icons.swap_horiz_rounded,
                      children: [
                        _InfoRow(
                            icon: Icons.person_rounded,
                            label: 'Nama Anggota',
                            value: d.anggota.nama),
                        _InfoRow(
                            icon: Icons.badge_rounded,
                            label: 'ID Anggota',
                            value: d.anggota.idAnggota.toString()),
                        _InfoRow(
                            icon: Icons.security_rounded,
                            label: 'Jaminan',
                            value: d.jaminan),
                        _InfoRow(
                            icon: Icons.calendar_today_rounded,
                            label: 'Tgl Pinjam',
                            value: d.tglPinjam.substring(0, 10)),
                        _InfoRow(
                            icon: Icons.event_rounded,
                            label: 'Harus Kembali',
                            value: d.tglHrsKembali.substring(0, 10)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      title: 'Detail Buku (${d.details.length})',
                      icon: Icons.menu_book_rounded,
                      children: d.details.isEmpty
                          ? [
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Tidak ada detail buku',
                                    style: TextStyle(
                                        color: AppTheme.onSurface,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            ]
                          : d.details
                              .asMap()
                              .entries
                              .map((e) => _BukuDetailTile(
                                    index: e.key + 1,
                                    idBuku: e.value.idBuku.toString(),
                                    kondisi: e.value.kondisi,
                                  ))
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.onBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.primary),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: AppTheme.onSurface),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _BukuDetailTile extends StatelessWidget {
  final int index;
  final String idBuku;
  final String kondisi;

  const _BukuDetailTile({
    required this.index,
    required this.idBuku,
    required this.kondisi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID Buku: $idBuku',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kondisi: $kondisi',
                  style: TextStyle(fontSize: 12, color: AppTheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
