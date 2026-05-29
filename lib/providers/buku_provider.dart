import 'package:flutter/material.dart';
import '../models/buku_model.dart';
import '../services/buku_service.dart';

class BukuProvider extends ChangeNotifier {
  final BukuService _service = BukuService();

  List<Buku> _list = [];
  bool _isLoading = false;
  String? _error;

  List<Buku> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _list = await _service.getAll();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(Map<String, dynamic> body) async {
    try {
      await _service.create(body);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String id, Map<String, dynamic> body) async {
    try {
      await _service.update({'id_buku': id, ...body});
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
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
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
