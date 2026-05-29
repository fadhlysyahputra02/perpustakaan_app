import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/peminjaman_model.dart';

class PeminjamanService {
  final Dio _dio = DioClient.instance;

  Future<List<Peminjaman>> getAll() async {
    final res = await _dio.get('/admin/peminjaman/');
    final List data = res.data['data'] ?? [];
    return data.map((e) => Peminjaman.fromJson(e)).toList();
  }

  Future<PeminjamanDetail> getDetail(String id) async {
    final res = await _dio.get('/admin/peminjaman/detail/$id');
    return PeminjamanDetail.fromJson(res.data['data']);
  }

  Future<void> create(Map<String, dynamic> body) async {
    await _dio.post('/admin/peminjaman/create', data: body);
  }

  Future<void> update(Map<String, dynamic> body) async {
    await _dio.put('/admin/peminjaman/update', data: body);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/admin/peminjaman/delete', data: {'id_peminjaman': id});
  }
}
