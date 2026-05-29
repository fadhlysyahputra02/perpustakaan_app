import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/auth_model.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<AuthModel> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final data = response.data;
      if (data['error'] == true) {
        throw Exception(data['msg'] ?? 'Login gagal');
      }

      return AuthModel.fromJson(data['data']);
    } on DioException catch (e) {
      final msg = e.response?.data['msg'] ?? 'Terjadi kesalahan jaringan';
      throw Exception(msg);
    }
  }
}
