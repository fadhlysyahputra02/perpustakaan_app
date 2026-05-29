import 'package:dio/dio.dart';

class DioErrorParser {
  static String parse(Object e) {
    if (e is DioException) {
      final data = e.response?.data;

      if (data is Map) {
        final msg = data['message'] ?? data['error'];
        if (msg is String && msg.trim().isNotEmpty) return msg.trim();

        if (data['errors'] is Map) {
          return (data['errors'] as Map)
              .entries
              .map((entry) => '${entry.key}: ${entry.value}')
              .join('\n');
        }
        if (data['errors'] is List) {
          return (data['errors'] as List).join('\n');
        }
      }

      switch (e.response?.statusCode) {
        case 400:
          return 'Data yang dikirim tidak valid';
        case 401:
          return 'Sesi habis, silakan login ulang';
        case 403:
          return 'Akses ditolak';
        case 404:
          return 'Data tidak ditemukan';
        case 409:
          return 'Data sudah ada';
        case null:
          return 'Tidak dapat terhubung ke server';
        default:
          return 'Terjadi kesalahan (${e.response?.statusCode})';
      }
    }
    return 'Gagal terhubung ke server, coba lagi';
  }
}
