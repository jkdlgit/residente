import 'package:shared_preferences/shared_preferences.dart';

class BaseDatosLocal {
  Future<String> leer(String _keyName) async {
    final prefs = await SharedPreferences.getInstance();
    String valor;
    try {
      valor = prefs.getString(_keyName.toUpperCase()) ?? null;
    } catch (e) {
      valor = null;
    }
    print('read: $valor');
    return valor;
  }

  void guardar(String _keyName, String _value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyName.toUpperCase();
    prefs.setString(key, _value);
  }
}
