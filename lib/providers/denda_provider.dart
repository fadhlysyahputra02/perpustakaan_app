import 'package:flutter/material.dart';
import '../models/denda_model.dart';
import '../services/denda_service.dart';

class DendaProvider extends ChangeNotifier {
  final DendaService _service = DendaService();

  List<Denda> list = [];
  bool isLoading = false;
  String? error;
  String? _mutationError;
  String? get mutationError => _mutationError;

  Future<void> fetchAll() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      list = await _service.getAll();
    } catch (e) {
      error = 'Gagal terhubung ke server, coba lagi';
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> create(Map<String, dynamic> body) async {
    try {
      await _service.create(body);
      await fetchAll();
      return true;
    } catch (e) {
      error = 'Gagal terhubung ke server, coba lagi';
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String id, Map<String, dynamic> body) async {
    try {
      body['id_denda'] = id;
      await _service.update(body);
      await fetchAll();
      return true;
    } catch (e) {
      error = 'Gagal terhubung ke server, coba lagi';
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _service.delete(id);
      await fetchAll();
      return true;
    } catch (e) {
      error = 'Gagal terhubung ke server, coba lagi';
      notifyListeners();
      return false;
    }
  }
}
