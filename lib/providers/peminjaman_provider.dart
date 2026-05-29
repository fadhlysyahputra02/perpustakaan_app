import 'package:flutter/material.dart';
import '../core/utils/dio_error_parser.dart';
import '../models/peminjaman_model.dart';
import '../services/peminjaman_service.dart';

class PeminjamanProvider extends ChangeNotifier {
  final PeminjamanService _service = PeminjamanService();

  // --- List state ---
  List<Peminjaman> _list = [];
  bool _listLoading = false;
  String? _listError;

  // --- Detail state ---
  PeminjamanDetail? _detail;
  bool _detailLoading = false;
  String? _detailError;

  // --- Mutation ---
  String? _mutationError;

  List<Peminjaman> get list => _list;
  bool get isLoading => _listLoading;
  String? get error => _listError;

  PeminjamanDetail? get detail => _detail;
  bool get isDetailLoading => _detailLoading;
  String? get detailError => _detailError;

  String? get mutationError => _mutationError;

  Future<void> fetchAll() async {
    _listLoading = true;
    _listError = null;
    notifyListeners();
    try {
      _list = await _service.getAll();
    } catch (e) {
      _listError = DioErrorParser.parse(e);
    } finally {
      _listLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetail(String id) async {
    _detailLoading = true;
    _detailError = null;
    _detail = null;
    notifyListeners();
    try {
      _detail = await _service.getDetail(id);
    } catch (e) {
      _detailError = DioErrorParser.parse(e);
    } finally {
      _detailLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(Map<String, dynamic> body) async {
    _mutationError = null;
    try {
      await _service.create(body);
      await fetchAll();
      return true;
    } catch (e) {
      _mutationError = DioErrorParser.parse(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String id, Map<String, dynamic> body) async {
    _mutationError = null;
    try {
      body['id_peminjaman'] = id;
      await _service.update(body);
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
