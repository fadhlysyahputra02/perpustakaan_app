import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../providers/denda_provider.dart';
import 'denda_form_screen.dart';

class DendaListScreen extends StatefulWidget {
  const DendaListScreen({super.key});

  @override
  State<DendaListScreen> createState() => _DendaListScreenState();
}

class _DendaListScreenState extends State<DendaListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DendaProvider>().fetchAll();
    });
  }

  void _confirmDelete(String id) {
    final provider = context.read<DendaProvider>();
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
                      final msg =
                          provider.mutationError ?? 'Gagal menghapus data';
                      final isSessionExpired = msg.contains('Sesi habis');
                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          icon: Icon(
                            isSessionExpired
                                ? Icons.lock_outline_rounded
                                : Icons.error_outline_rounded,
                            color: isSessionExpired
                                ? Colors.orange
                                : AppTheme.error,
                            size: 44,
                          ),
                          title: Text(
                            isSessionExpired ? 'Sesi Habis' : 'Gagal Menghapus',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            isSessionExpired
                                ? 'Sesi login kamu sudah habis.\nMengalihkan ke halaman login...'
                                : msg,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            FilledButton(
                              style: isSessionExpired
                                  ? FilledButton.styleFrom(
                                      backgroundColor: AppTheme.error)
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
                              child:
                                  Text(isSessionExpired ? 'Keluar' : 'Tutup'),
                            ),
                          ],
                        ),
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
          'Denda',
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
            MaterialPageRoute(builder: (_) => const DendaFormScreen()),
          );
          if (mounted) context.read<DendaProvider>().fetchAll();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BgPainter())),
          Consumer<DendaProvider>(
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
                      Icon(Icons.receipt_long_rounded,
                          size: 64, color: AppTheme.primary.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada data denda',
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
                  final tglKembali = item.tglKembali.length >= 10
                      ? item.tglKembali.substring(0, 10)
                      : '-';
                  return _DendaCard(
                    idAnggota: item.idAnggota.toString(),
                    jumlahDenda: item.jumlahDenda.toString(),
                    tglKembali: tglKembali,
                    onDelete: () => _confirmDelete(item.idDenda),
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

class _DendaCard extends StatelessWidget {
  final String idAnggota;
  final String jumlahDenda;
  final String tglKembali;
  final VoidCallback onDelete;

  const _DendaCard({
    required this.idAnggota,
    required this.jumlahDenda,
    required this.tglKembali,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.error.withOpacity(0.07),
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
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: AppTheme.error,
                size: 28,
              ),
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
                    'Rp $jumlahDenda',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.error,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_rounded,
                            size: 11, color: AppTheme.error),
                        const SizedBox(width: 4),
                        Text(
                          'Kembali: $tglKembali',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.error,
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
                child:
                    Icon(Icons.delete_rounded, color: AppTheme.error, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
