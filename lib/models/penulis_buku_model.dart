class PenulisBuku {
  final String id;
  final String penulisBuku;
  final String alamatPenulis;
  final String emailPenulis;
  final String deskripsi;
  final String? updatedAt;

  PenulisBuku({
    required this.id,
    required this.penulisBuku,
    required this.alamatPenulis,
    required this.emailPenulis,
    required this.deskripsi,
    this.updatedAt,
  });

  factory PenulisBuku.fromJson(Map<String, dynamic> json) {
    return PenulisBuku(
      id: json['id'] ?? '',
      penulisBuku: json['penulis_buku'] ?? '',
      alamatPenulis: json['alamat'] ?? '',
      emailPenulis: json['email_penulis'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'penulis_buku': penulisBuku,
        'alamat_penulis': alamatPenulis,
        'email_penulis': emailPenulis,
        'deskripsi': deskripsi,
      };
}
