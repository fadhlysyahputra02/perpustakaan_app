import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../models/penerbit_buku_model.dart';
import '../../providers/penerbit_buku_provider.dart';

class PenerbitFormScreen extends StatefulWidget {
  final PenerbitBuku? penerbit;
  const PenerbitFormScreen({super.key, this.penerbit});

  @override
  State<PenerbitFormScreen> createState() => _PenerbitFormScreenState();
}

class _PenerbitFormScreenState extends State<PenerbitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaCtr;
  late TextEditingController _alamatCtr;
  late TextEditingController _telpCtr;
  late TextEditingController _emailCtr;
  late TextEditingController _deskripsiCtr;
  bool _isSubmitting = false;

  bool get isEdit => widget.penerbit != null;

  @override
  void initState() {
    super.initState();
    _namaCtr = TextEditingController(text: widget.penerbit?.penerbitBuku ?? '');
    _alamatCtr =
        TextEditingController(text: widget.penerbit?.alamatPenerbit ?? '');
    _telpCtr = TextEditingController(text: widget.penerbit?.telpPenerbit ?? '');
    _emailCtr =
        TextEditingController(text: widget.penerbit?.emailPenerbit ?? '');
    _deskripsiCtr =
        TextEditingController(text: widget.penerbit?.deskripsiPenerbit ?? '');
  }

  @override
  void dispose() {
    _namaCtr.dispose();
    _alamatCtr.dispose();
    _telpCtr.dispose();
    _emailCtr.dispose();
    _deskripsiCtr.dispose();
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

    final body = {
      'penerbit_buku': _namaCtr.text.trim(),
      'alamat_penerbit': _alamatCtr.text.trim(),
      'telp_penerbit': _telpCtr.text.trim(),
      'email_penerbit': _emailCtr.text.trim(),
      'deskripsi':
          _deskripsiCtr.text.trim().isEmpty ? '-' : _deskripsiCtr.text.trim(),
    };

    final provider = context.read<PenerbitBukuProvider>();
    final success = isEdit
        ? await provider.update(widget.penerbit!.id, body)
        : await provider.create(body);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      await _showResultDialog(
        isSuccess: true,
        message: isEdit
            ? 'Penerbit berhasil diupdate'
            : 'Penerbit berhasil ditambahkan',
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
          isEdit ? 'Edit Penerbit' : 'Tambah Penerbit',
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
                  _SectionCard(
                    title: 'Informasi Penerbit',
                    icon: Icons.business_rounded,
                    children: [
                      TextFormField(
                        controller: _namaCtr,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nama Penerbit',
                          prefixIcon: Icon(Icons.business_rounded),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Nama penerbit wajib diisi';
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
                        controller: _emailCtr,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Penerbit',
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          final emailRegex =
                              RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
                          if (!emailRegex.hasMatch(v.trim())) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _telpCtr,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Telepon Penerbit',
                          prefixIcon: Icon(Icons.phone_rounded),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Telepon wajib diisi';
                          }
                          final phoneRegex = RegExp(r'^[0-9+\-\s]{7,15}$');
                          if (!phoneRegex.hasMatch(v.trim())) {
                            return 'Format telepon tidak valid';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: 'Informasi Tambahan',
                    icon: Icons.info_rounded,
                    children: [
                      TextFormField(
                        controller: _alamatCtr,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Alamat Penerbit',
                          prefixIcon: Icon(Icons.location_on_rounded),
                          helperText: 'Minimal 5 karakter',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Alamat wajib diisi';
                          }
                          if (v.trim().length < 5) {
                            return 'Minimal 5 karakter';
                          }
                          if (v.trim().length > 255) {
                            return 'Maksimal 255 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _deskripsiCtr,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi (opsional)',
                          prefixIcon: Icon(Icons.description_rounded),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
