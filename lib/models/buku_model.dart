class Buku {
  final String idBuku;
  final String isbn;
  final String idKategoriBuku;
  final String judulBuku;
  final String idPenulisBuku;
  final String idPenerbitBuku;
  final String tahunTerbit;
  final int stokBuku;
  final String rakBuku;
  final String deskripsiBuku;
  final String gambarBuku;
  final String kondisiBuku;
  final String? createdAt;
  final String? updatedAt;

  Buku({
    required this.idBuku,
    required this.isbn,
    required this.idKategoriBuku,
    required this.judulBuku,
    required this.idPenulisBuku,
    required this.idPenerbitBuku,
    required this.tahunTerbit,
    required this.stokBuku,
    required this.rakBuku,
    required this.deskripsiBuku,
    required this.gambarBuku,
    required this.kondisiBuku,
    this.createdAt,
    this.updatedAt,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      idBuku: json['id_buku'] ?? '',
      isbn: json['isbn'] ?? '',
      idKategoriBuku: json['id_kategori_buku'] ?? '',
      judulBuku: json['judul_buku'] ?? '',
      idPenulisBuku: json['id_penulis_buku'] ?? '',
      idPenerbitBuku: json['id_penerbit_buku'] ?? '',
      tahunTerbit: json['tahun_terbit'] ?? '',
      stokBuku: json['stok_buku'] ?? 0,
      rakBuku: json['rak_buku'] ?? '',
      deskripsiBuku: json['deskripsi_buku'] ?? '',
      gambarBuku: json['gambar_buku'] ?? '',
      kondisiBuku: json['kondisi_buku'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_buku': idBuku,
        'isbn': isbn,
        'id_kategori_buku': idKategoriBuku,
        'judul_buku': judulBuku,
        'id_penulis_buku': idPenulisBuku,
        'id_penerbit_buku': idPenerbitBuku,
        'tahun_terbit': tahunTerbit,
        'stok_buku': stokBuku,
        'rak_buku': rakBuku,
        'deskripsi_buku': deskripsiBuku,
        'gambar_buku': gambarBuku,
        'kondisi_buku': kondisiBuku,
      };
}
