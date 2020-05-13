import 'package:shared_preferences/shared_preferences.dart';
//ARCHIVO  .yaml
//shared_preferences: ^0.5.6+1

class LocalDataBase {
  Future<String> read(String _keyName) async {
    final prefs = await SharedPreferences.getInstance();
    String value = null;
    try {
      value = prefs.getString(_keyName.toUpperCase()) ?? null;
    } catch (e) {
      value = null;
    }
    print('read: $value');
    return value;
  }

  void save(String _keyName, String _value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyName.toUpperCase();
    prefs.setString(key, _value);
    _readx(_keyName);
  }

  void _readx(String _keyName) async {
    final prefs = await SharedPreferences.getInstance();
    final _value = prefs.getString(_keyName.toUpperCase()) ?? 'vacio';
    print('read: $_value');
  }
}
