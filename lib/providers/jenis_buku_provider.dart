import 'package:flutter/material.dart';
import '../core/utils/dio_error_parser.dart';
import '../models/jenis_buku_model.dart';
import '../services/jenis_buku_service.dart';

class JenisBukuProvider extends ChangeNotifier {
  final JenisBukuService _service = JenisBukuService();

  List<JenisBuku> _list = [];
  bool _isLoading = false;
  String? _fetchError;
  String? _mutationError;

  List<JenisBuku> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _fetchError;
  String? get mutationError => _mutationError;

  Future<void> fetchAll() async {
    _isLoading = true;
    _fetchError = null;
    notifyListeners();
    try {
      _list = await _service.getAll();
    } catch (e) {
      _fetchError = DioErrorParser.parse(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(String jenisBuku, String deskripsi) async {
    _mutationError = null;
    try {
      await _service.create(jenisBuku, deskripsi);
      await fetchAll();
      return true;
    } catch (e) {
      _mutationError = DioErrorParser.parse(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String id, String jenisBuku, String deskripsi) async {
    _mutationError = null;
    try {
      await _service.update(id, jenisBuku, deskripsi);
      await fetchAll();
      return true;
    } catch (e) {
      _mutationError = DioErrorParser.parse(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    _mutationError = null;
    try {
      await _service.delete(id);
      await fetchAll();
      return true;
    } catch (e) {
      _mutationError = DioErrorParser.parse(e);
      notifyListeners();
      return false;
    }
  }
}
