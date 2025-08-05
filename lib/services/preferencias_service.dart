// lib/services/preferencias_service.dart

import 'package:shared_preferences/shared_preferences.dart';

const String _keyPlataforma = 'plataforma_usuario';

/// Salva a plataforma escolhida pelo usuário.
Future<void> salvarPlataforma(String plataforma) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_keyPlataforma, plataforma);
}

/// Carrega a plataforma salva anteriormente.
Future<String?> carregarPlataforma() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_keyPlataforma);
}