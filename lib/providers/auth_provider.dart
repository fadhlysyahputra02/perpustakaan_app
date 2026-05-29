import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../core/utils/token_helper.dart';
import '../models/auth_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  String _errorMessage = '';
  String _username = '';

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get username => _username;

  Future<void> checkLoginStatus() async {
    final loggedIn = await TokenHelper.isLoggedIn();
    if (loggedIn) {
      _username = (await TokenHelper.getUsername()) ?? '';
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final AuthModel auth = await _authService.login(username, password);
      await TokenHelper.saveToken(auth.token, auth.refreshToken, auth.username);
      _username = auth.username;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await TokenHelper.clearToken();
    _username = '';
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
