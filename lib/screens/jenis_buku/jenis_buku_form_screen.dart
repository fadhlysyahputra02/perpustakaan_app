import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../models/jenis_buku_model.dart';
import '../../providers/jenis_buku_provider.dart';

class JenisBukuFormScreen extends StatefulWidget {
  final JenisBuku? jenisBuku;
  const JenisBukuFormScreen({super.key, this.jenisBuku});

  @override
  State<JenisBukuFormScreen> createState() => _JenisBukuFormScreenState();
}

class _JenisBukuFormScreenState extends State<JenisBukuFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jenisBukuController;
  late TextEditingController _deskripsiController;
  bool _isSubmitting = false;

  bool get isEdit => widget.jenisBuku != null;

  @override
  void initState() {
    super.initState();
    _jenisBukuController =
        TextEditingController(text: widget.jenisBuku?.jenisBuku ?? '');
    _deskripsiController =
        TextEditingController(text: widget.jenisBuku?.deskripsi ?? '');
  }

  @override
  void dispose() {
    _jenisBukuController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _showResultDialog({
    required bool isSuccess,
    required String message,
  }) {
    final isSessionExpired = message.contains('Sesi habis');

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(
          isSuccess
              ? Icons.check_circle_outline_rounded
              : isSessionExpired
                  ? Icons.lock_outline_rounded
                  : Icons.error_outline_rounded,
          color: isSuccess
              ? const Color(0xFF388E3C)
              : isSessionExpired
                  ? Colors.orange
                  : Colors.red,
          size: 44,
        ),
        title: Text(
          isSuccess
              ? 'Berhasil'
              : isSessionExpired
                  ? 'Sesi Habis'
                  : 'Gagal',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isSessionExpired
              ? 'Sesi login kamu sudah habis.\nSilakan login ulang untuk melanjutkan.'
              : message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          if (isSessionExpired)
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isSuccess ? 'Oke' : 'Tutup'),
            ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final provider = context.read<JenisBukuProvider>();
    final success = isEdit
        ? await provider.update(
            widget.jenisBuku!.id,
            _jenisBukuController.text.trim(),
            _deskripsiController.text.trim(),
          )
        : await provider.create(
            _jenisBukuController.text.trim(),
            _deskripsiController.text.trim(),
          );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      await _showResultDialog(
        isSuccess: true,
        message: isEdit
            ? 'Jenis buku berhasil diupdate'
            : 'Jenis buku berhasil ditambahkan',
      );
      if (mounted) Navigator.pop(context);
    } else {
      await _showResultDialog(
        isSuccess: false,
        message: provider.mutationError ?? 'Gagal menyimpan data',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(
          isEdit ? 'Edit Jenis Buku' : 'Tambah Jenis Buku',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BgPainter())),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
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
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.category_rounded,
                                  color: AppTheme.primary, size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Informasi Jenis Buku',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _jenisBukuController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Jenis Buku',
                            prefixIcon: Icon(Icons.label_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Jenis buku wajib diisi';
                            }
                            if (v.trim().length < 3) {
                              return 'Minimal 3 karakter';
                            }
                            if (v.trim().length > 255) {
                              return 'Maksimal 255 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _deskripsiController,
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                            prefixIcon: Icon(Icons.description_rounded),
                            alignLabelWithHint: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Deskripsi wajib diisi';
                            }
                            if (v.trim().length < 3) {
                              return 'Minimal 3 karakter';
                            }
                            if (v.trim().length > 255) {
                              return 'Maksimal 255 karakter';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(isEdit
                              ? Icons.save_rounded
                              : Icons.check_rounded),
                      label: Text(
                        _isSubmitting
                            ? 'Menyimpan...'
                            : isEdit
                                ? 'Update'
                                : 'Simpan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
