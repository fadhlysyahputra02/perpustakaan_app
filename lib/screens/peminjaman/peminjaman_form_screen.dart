import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../models/peminjaman_model.dart';
import '../../providers/peminjaman_provider.dart';

class PeminjamanFormScreen extends StatefulWidget {
  final Peminjaman? peminjaman;
  const PeminjamanFormScreen({super.key, this.peminjaman});

  @override
  State<PeminjamanFormScreen> createState() => _PeminjamanFormScreenState();
}

class _PeminjamanFormScreenState extends State<PeminjamanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idAnggotaCtr;
  late TextEditingController _jaminanCtr;
  DateTime? _tglPinjam;
  DateTime? _tglHrsKembali;

  bool get isEdit => widget.peminjaman != null;

  @override
  void initState() {
    super.initState();
    _idAnggotaCtr =
        TextEditingController(text: widget.peminjaman?.idAnggota ?? '');
    _jaminanCtr = TextEditingController(text: widget.peminjaman?.jaminan ?? '');
    if (widget.peminjaman != null) {
      _tglPinjam = DateTime.tryParse(widget.peminjaman!.tglPinjam);
      _tglHrsKembali = DateTime.tryParse(widget.peminjaman!.tglHrsKembali);
    }
  }

  @override
  void dispose() {
    _idAnggotaCtr.dispose();
    _jaminanCtr.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isPinjam) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tglPinjam = picked;
        } else {
          _tglHrsKembali = picked;
        }
      });
    }
  }

  String _fmt(DateTime? dt) =>
      dt == null ? 'Belum dipilih' : dt.toLocal().toString().substring(0, 10);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tglPinjam == null || _tglHrsKembali == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tanggal wajib diisi'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final body = {
      'id_anggota': _idAnggotaCtr.text.trim(),
      'tgl_pinjam': '${_tglPinjam!.toUtc().toIso8601String().split('.')[0]}Z',
      'tgl_hrs_kembali':
          '${_tglHrsKembali!.toUtc().toIso8601String().split('.')[0]}Z',
      'jaminan': _jaminanCtr.text.trim(),
    };

    final provider = context.read<PeminjamanProvider>();
    final success = isEdit
        ? await provider.update(widget.peminjaman!.id, body)
        : await provider.create(body);

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Gagal menyimpan data'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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
          isEdit ? 'Edit Peminjaman' : 'Tambah Peminjaman',
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
              child: Column(
                children: [
                  // Section: Informasi Anggota
                  _SectionCard(
                    title: 'Informasi Peminjaman',
                    icon: Icons.swap_horiz_rounded,
                    color: AppTheme.primary,
                    children: [
                      TextFormField(
                        controller: _idAnggotaCtr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'ID Anggota',
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _jaminanCtr,
                        decoration: const InputDecoration(
                          labelText: 'Jaminan',
                          prefixIcon: Icon(Icons.shield_rounded),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Jaminan wajib diisi';
                          if (v.trim().length < 3)
                            return 'Jaminan minimal 3 karakter';
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Section: Tanggal
                  _SectionCard(
                    title: 'Tanggal Peminjaman',
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF00897B),
                    children: [
                      _DateTile(
                        label: 'Tanggal Pinjam',
                        value: _fmt(_tglPinjam),
                        isSelected: _tglPinjam != null,
                        onTap: () => _pickDate(true),
                      ),
                      const SizedBox(height: 10),
                      _DateTile(
                        label: 'Tanggal Harus Kembali',
                        value: _fmt(_tglHrsKembali),
                        isSelected: _tglHrsKembali != null,
                        onTap: () => _pickDate(false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: Icon(
                          isEdit ? Icons.save_rounded : Icons.check_rounded),
                      label: Text(isEdit ? 'Update' : 'Simpan'),
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

// ── Reusable Section Card ──────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
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
            color: color.withOpacity(0.07),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
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

// ── Date Tile ──────────────────────────────────────────────────────────────
class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.06)
              : AppTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary.withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: isSelected ? AppTheme.primary : AppTheme.onSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppTheme.primary : AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.primary.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
