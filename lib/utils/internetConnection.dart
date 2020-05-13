import 'package:data_connection_checker/data_connection_checker.dart';

class ConnctionTest {
  static Future<bool> _conn() async {
    return await DataConnectionChecker().hasConnection.then(
      (val) {
        if (val) {
          return true;
        } else {
          return false;
        }
      },
    );
  }

  static bool verifyConnection() {
    _conn().then(
      (val) {
        return val;
      },
    );
  }
}
