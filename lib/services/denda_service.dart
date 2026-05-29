import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/denda_model.dart';

class DendaService {
  final Dio _dio = DioClient.instance;

  Future<List<Denda>> getAll() async {
    final res = await _dio.get('/admin/denda/');
    final List data = res.data['data'] ?? [];
    return data.map((e) => Denda.fromJson(e)).toList();
  }

  Future<Denda> getById(String id) async {
    final res = await _dio.get('/admin/denda/$id');
    return Denda.fromJson(res.data['data']);
  }

  Future<void> create(Map<String, dynamic> body) async {
    await _dio.post('/admin/denda/create', data: body);
  }

  Future<void> update(Map<String, dynamic> body) async {
    await _dio.put('/admin/denda/update', data: body);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/admin/denda/delete', data: {'id_denda': id});
  }
}
