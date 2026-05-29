import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/bg_painter.dart';
import '../../models/denda_model.dart';
import '../../providers/denda_provider.dart';

class DendaFormScreen extends StatefulWidget {
  final Denda? denda;
  const DendaFormScreen({super.key, this.denda});

  @override
  State<DendaFormScreen> createState() => _DendaFormScreenState();
}

class _DendaFormScreenState extends State<DendaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jumlahCtr;
  late TextEditingController _idPeminjamanCtr;
  late TextEditingController _idAnggotaCtr;
  DateTime? _tglPinjam;
  DateTime? _tglHrsKembali;
  DateTime? _tglKembali;

  bool get isEdit => widget.denda != null;

  @override
  void initState() {
    super.initState();
    _jumlahCtr =
        TextEditingController(text: widget.denda?.jumlahDenda.toString() ?? '');
    _idPeminjamanCtr =
        TextEditingController(text: widget.denda?.idPeminjaman ?? '');
    _idAnggotaCtr = TextEditingController(text: widget.denda?.idAnggota ?? '');
    if (widget.denda != null) {
      _tglPinjam = DateTime.tryParse(widget.denda!.tglPinjam);
      _tglHrsKembali = DateTime.tryParse(widget.denda!.tglHrsKembali);
      _tglKembali = DateTime.tryParse(widget.denda!.tglKembali);
    }
  }

  @override
  void dispose() {
    _jumlahCtr.dispose();
    _idPeminjamanCtr.dispose();
    _idAnggotaCtr.dispose();
    super.dispose();
  }

  Future<void> _pickDate(String field) async {
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
        if (field == 'pinjam') _tglPinjam = picked;
        if (field == 'hrs_kembali') _tglHrsKembali = picked;
        if (field == 'kembali') _tglKembali = picked;
      });
    }
  }

  String _fmt(DateTime? dt) =>
      dt == null ? 'Belum dipilih' : dt.toLocal().toString().substring(0, 10);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tglPinjam == null || _tglHrsKembali == null || _tglKembali == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua tanggal wajib diisi'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    String toIso(DateTime dt) =>
        '${dt.toUtc().toIso8601String().split('.')[0]}Z';

    final body = {
      'jumlah_denda': int.tryParse(_jumlahCtr.text.trim()) ?? 0,
      'tgl_pinjam': toIso(_tglPinjam!),
      'tgl_hrs_kembali': toIso(_tglHrsKembali!),
      'tgl_kembali': toIso(_tglKembali!),
      'id_peminjaman': _idPeminjamanCtr.text.trim(),
      'id_anggota': _idAnggotaCtr.text.trim(),
    };

    final provider = context.read<DendaProvider>();
    final success = isEdit
        ? await provider.update(widget.denda!.idDenda, body)
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
          isEdit ? 'Edit Denda' : 'Tambah Denda',
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
                  // Section: Informasi Denda
                  _SectionCard(
                    title: 'Informasi Denda',
                    icon: Icons.receipt_long_rounded,
                    color: AppTheme.error,
                    children: [
                      TextFormField(
                        controller: _jumlahCtr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Denda (Rp)',
                          prefixIcon: Icon(Icons.payments_rounded),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _idPeminjamanCtr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'ID Peminjaman',
                          prefixIcon: Icon(Icons.swap_horiz_rounded),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 14),
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
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Section: Tanggal
                  _SectionCard(
                    title: 'Tanggal',
                    icon: Icons.calendar_month_rounded,
                    color: AppTheme.primary,
                    children: [
                      _DateTile(
                        label: 'Tanggal Pinjam',
                        value: _fmt(_tglPinjam),
                        isSelected: _tglPinjam != null,
                        onTap: () => _pickDate('pinjam'),
                      ),
                      const SizedBox(height: 10),
                      _DateTile(
                        label: 'Tanggal Harus Kembali',
                        value: _fmt(_tglHrsKembali),
                        isSelected: _tglHrsKembali != null,
                        onTap: () => _pickDate('hrs_kembali'),
                      ),
                      const SizedBox(height: 10),
                      _DateTile(
                        label: 'Tanggal Kembali',
                        value: _fmt(_tglKembali),
                        isSelected: _tglKembali != null,
                        onTap: () => _pickDate('kembali'),
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
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.onSurface,
                    ),
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
