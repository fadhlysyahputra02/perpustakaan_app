class Peminjaman {
  final String id;
  final String idAnggota;
  final String tglPinjam;
  final String tglHrsKembali;
  final String jaminan;
  final String createdAt;

  Peminjaman({
    required this.id,
    required this.idAnggota,
    required this.tglPinjam,
    required this.tglHrsKembali,
    required this.jaminan,
    required this.createdAt,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) => Peminjaman(
        id: json['id'] ?? '',
        idAnggota: json['id_anggota'] ?? '',
        tglPinjam: json['tgl_pinjam'] ?? '',
        tglHrsKembali: json['tgl_hrs_kembali'] ?? '',
        jaminan: json['jaminan'] ?? '',
        createdAt: json['created_at'] ?? '',
      );
}

class PeminjamanDetail {
  final String id;
  final AnggotaDetail anggota;
  final String tglPinjam;
  final String tglHrsKembali;
  final String jaminan;
  final List<DetailPinjam> details;

  PeminjamanDetail({
    required this.id,
    required this.anggota,
    required this.tglPinjam,
    required this.tglHrsKembali,
    required this.jaminan,
    required this.details,
  });

  factory PeminjamanDetail.fromJson(Map<String, dynamic> json) =>
      PeminjamanDetail(
        id: json['id'] ?? '',
        anggota: AnggotaDetail.fromJson(json['anggota'] ?? {}),
        tglPinjam: json['tgl_pinjam'] ?? '',
        tglHrsKembali: json['tgl_hrs_kembali'] ?? '',
        jaminan: json['jaminan'] ?? '',
        details: (json['details'] as List? ?? [])
            .map((e) => DetailPinjam.fromJson(e))
            .toList(),
      );
}

class AnggotaDetail {
  final String idAnggota;
  final String nama;

  AnggotaDetail({required this.idAnggota, required this.nama});

  factory AnggotaDetail.fromJson(Map<String, dynamic> json) => AnggotaDetail(
        idAnggota: json['id_anggota'] ?? '',
        nama: json['nama'] ?? '',
      );
}

class DetailPinjam {
  final String idDetailpinjam;
  final String idBuku;
  final String kondisi;

  DetailPinjam({
    required this.idDetailpinjam,
    required this.idBuku,
    required this.kondisi,
  });

  factory DetailPinjam.fromJson(Map<String, dynamic> json) => DetailPinjam(
        idDetailpinjam: json['id_detailpinjam'] ?? '',
        idBuku: json['id_buku'] ?? '',
        kondisi: json['kondisi'] ?? '',
      );
}
