import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future setToken(String token) async =>
      await _storage.write(key: "jwt", value: token);

  static Future setUsername(String username) async =>
      await _storage.write(key: "username", value: username);

  static Future setFirstName(String firstName) async =>
      await _storage.write(key: "firstName", value: firstName);

  static Future setLastName(String lastName) async =>
      await _storage.write(key: "lastName", value: lastName);
}