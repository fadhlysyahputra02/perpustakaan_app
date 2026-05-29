import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/buku_model.dart';

class BukuService {
  final Dio _dio = DioClient.instance;

  Future<List<Buku>> getAll() async {
    final res = await _dio.get('/buku');
    final List data = res.data['data'] ?? [];
    return data.map((e) => Buku.fromJson(e)).toList();
  }

  Future<Buku> getById(String id) async {
    final res = await _dio.get('/buku/$id');
    return Buku.fromJson(res.data['data']);
  }

  Future<void> create(Map<String, dynamic> body) async {
    await _dio.post('/admin/buku/create', data: body);
  }

  Future<void> update(Map<String, dynamic> body) async {
    await _dio.put('/admin/buku/update', data: body);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/admin/buku/delete', data: {'id_buku': id});
  }
}
