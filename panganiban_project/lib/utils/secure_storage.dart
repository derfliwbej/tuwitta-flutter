import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future setToken(String token) async =>
      await _storage.write(key: "jwt", value: token);
}