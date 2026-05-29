import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/penerbit_buku_model.dart';

class PenerbitService {
  final Dio _dio = DioClient.instance;

  Future<List<PenerbitBuku>> getAll() async {
    final res = await _dio.get('/admin/buku/penbuk/');
    final List data = res.data['data'] ?? [];
    return data.map((e) => PenerbitBuku.fromJson(e)).toList();
  }

  Future<PenerbitBuku> getById(String id) async {
    final res = await _dio.get('/admin/buku/penbuk/$id');
    return PenerbitBuku.fromJson(res.data['data']);
  }

  Future<void> create(Map<String, dynamic> body) async {
    await _dio.post('/admin/buku/penbuk/create', data: body);
  }

  Future<void> update(Map<String, dynamic> body) async {
    await _dio.put('/admin/buku/penbuk/update', data: body);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/admin/buku/penbuk/delete', data: {'id': id});
  }
}
