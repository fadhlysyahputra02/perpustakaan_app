class JenisBuku {
  final String id;
  final String jenisBuku;
  final String deskripsi;
  final String? updatedAt;

  JenisBuku({
    required this.id,
    required this.jenisBuku,
    required this.deskripsi,
    this.updatedAt,
  });

  factory JenisBuku.fromJson(Map<String, dynamic> json) {
    return JenisBuku(
      id: json['id'] ?? '',
      jenisBuku: json['jenis_buku'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'jenis_buku': jenisBuku,
        'deskripsi': deskripsi,
      };
}
