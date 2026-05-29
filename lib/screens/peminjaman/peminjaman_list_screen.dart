import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../providers/peminjaman_provider.dart';
import 'peminjaman_detail_screen.dart';
import 'peminjaman_form_screen.dart';

class PeminjamanListScreen extends StatefulWidget {
  const PeminjamanListScreen({super.key});

  @override
  State<PeminjamanListScreen> createState() => _PeminjamanListScreenState();
}

class _PeminjamanListScreenState extends State<PeminjamanListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PeminjamanProvider>().fetchAll();
    });
  }

  Future<void> _showErrorDialog(String message) {
    final isSessionExpired = message.contains('Sesi habis');
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(
          isSessionExpired
              ? Icons.lock_outline_rounded
              : Icons.error_outline_rounded,
          color: isSessionExpired ? Colors.orange : Colors.red,
          size: 48,
        ),
        title: Text(
          isSessionExpired ? 'Sesi Habis' : 'Gagal Menghapus',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isSessionExpired
              ? 'Sesi login kamu sudah habis.\nMengalihkan ke halaman login...'
              : message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            style: isSessionExpired
                ? FilledButton.styleFrom(backgroundColor: AppTheme.error)
                : null,
            onPressed: () {
              if (isSessionExpired) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(isSessionExpired ? 'Keluar' : 'Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    final provider = context.read<PeminjamanProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: AppTheme.error, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hapus Data?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data yang dihapus tidak dapat\ndikembalikan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 4),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style:
                      FilledButton.styleFrom(backgroundColor: AppTheme.error),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final success = await provider.delete(id);
                    if (!mounted) return;
                    if (!success) {
                      await _showErrorDialog(
                        provider.mutationError ?? 'Gagal menghapus data',
                      );
                    }
                  },
                  child: const Text('Hapus'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Peminjaman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PeminjamanFormScreen()),
          );
          if (mounted) context.read<PeminjamanProvider>().fetchAll();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BgPainter())),
          Consumer<PeminjamanProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.error != null) {
                final isSessionExpired = provider.error!.contains('Sesi habis');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSessionExpired
                              ? Icons.lock_outline_rounded
                              : Icons.error_outline,
                          color:
                              isSessionExpired ? Colors.orange : AppTheme.error,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isSessionExpired
                              ? 'Sesi login kamu sudah habis.\nSilakan login ulang.'
                              : provider.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSessionExpired
                                ? Colors.orange
                                : AppTheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isSessionExpired)
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.error),
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text('Keluar'),
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            },
                          )
                        else
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
              if (provider.list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swap_horiz_rounded,
                          size: 64, color: AppTheme.primary.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada data peminjaman',
                        style:
                            TextStyle(color: AppTheme.onSurface, fontSize: 15),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: provider.list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = provider.list[index];
                  final tgl = item.tglPinjam.length >= 10
                      ? item.tglPinjam.substring(0, 10)
                      : item.tglPinjam;
                  return _PeminjamanCard(
                    idAnggota: item.idAnggota.toString(),
                    jaminan: item.jaminan,
                    tglPinjam: tgl,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PeminjamanDetailScreen(id: item.id),
                      ),
                    ),
                    onDelete: () => _confirmDelete(item.id),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PeminjamanCard extends StatelessWidget {
  final String idAnggota;
  final String jaminan;
  final String tglPinjam;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PeminjamanCard({
    required this.idAnggota,
    required this.jaminan,
    required this.tglPinjam,
    required this.onTap,
    required this.onDelete,
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
                child: Icon(Icons.swap_horiz_rounded,
                    color: AppTheme.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anggota #$idAnggota',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jaminan: $jaminan',
                      style: TextStyle(fontSize: 12, color: AppTheme.onSurface),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 11, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            tglPinjam,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_rounded,
                      color: AppTheme.error, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
