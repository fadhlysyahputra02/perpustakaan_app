import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/penulis_buku_model.dart';

class PenulisService {
  final Dio _dio = DioClient.instance;

  Future<List<PenulisBuku>> getAll() async {
    final res = await _dio.get('/admin/buku/author/');
    final List data = res.data['data'] ?? [];
    return data.map((e) => PenulisBuku.fromJson(e)).toList();
  }

  Future<PenulisBuku> getById(String id) async {
    final res = await _dio.get('/admin/buku/author/$id');
    return PenulisBuku.fromJson(res.data['data']);
  }

  Future<void> create(Map<String, dynamic> body) async {
    await _dio.post('/admin/buku/author/create', data: body);
  }

  Future<void> update(Map<String, dynamic> body) async {
    await _dio.put('/admin/buku/author/update', data: body);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/admin/buku/author/delete', data: {'id': id});
  }
}
