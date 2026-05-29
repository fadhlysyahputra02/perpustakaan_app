class PenerbitBuku {
  final String id;
  final String penerbitBuku;
  final String alamatPenerbit;
  final String telpPenerbit;
  final String emailPenerbit;
  final String deskripsiPenerbit;
  final String? updatedAt;

  PenerbitBuku({
    required this.id,
    required this.penerbitBuku,
    required this.alamatPenerbit,
    required this.telpPenerbit,
    required this.emailPenerbit,
    required this.deskripsiPenerbit,
    this.updatedAt,
  });

  factory PenerbitBuku.fromJson(Map<String, dynamic> json) {
    return PenerbitBuku(
      id: json['id'] ?? '',
      penerbitBuku: json['penerbit_buku'] ?? '',
      alamatPenerbit: json['alamat_penerbit'] ?? '',
      telpPenerbit: json['telp_penerbit'] ?? '',
      emailPenerbit: json['email_penerbit'] ?? '',
      deskripsiPenerbit: json['deskripsi_penerbit'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'penerbit_buku': penerbitBuku,
        'alamat_penerbit': alamatPenerbit,
        'telp_penerbit': telpPenerbit,
        'email_penerbit': emailPenerbit,
        'deskripsi_penerbit': deskripsiPenerbit,
      };
}
