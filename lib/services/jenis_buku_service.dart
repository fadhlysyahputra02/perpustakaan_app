import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/jenis_buku_model.dart';

class JenisBukuService {
  final Dio _dio = DioClient.instance;

  Future<List<JenisBuku>> getAll() async {
    final res = await _dio.get('/admin/buku/jenbuk/');
    final List data = res.data['data'] ?? [];
    return data.map((e) => JenisBuku.fromJson(e)).toList();
  }

  Future<JenisBuku> getById(String id) async {
    final res = await _dio.get('/admin/buku/jenbuk/$id');
    return JenisBuku.fromJson(res.data['data']);
  }

  Future<void> create(String jenisBuku, String deskripsi) async {
    await _dio.post('/admin/buku/jenbuk/create', data: {
      'jenis_buku': jenisBuku,
      'deskripsi': deskripsi,
    });
  }

  Future<void> update(String id, String jenisBuku, String deskripsi) async {
    await _dio.put('/admin/buku/jenbuk/update', data: {
      'id': id,
      'jenis_buku': jenisBuku,
      'deskripsi': deskripsi,
    });
  }

  Future<void> delete(String id) async {
    await _dio.delete('/admin/buku/jenbuk/delete', data: {'id': id});
  }
}
