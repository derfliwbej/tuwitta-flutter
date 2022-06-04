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

  static Future<String?> getToken() async {
    final jwt = await _storage.read(key: "jwt");

    return jwt;
  }

  static Future<String?> getUsername() async {
    final username = await _storage.read(key: "username");

    return username;
  }

  static Future deleteToken() async =>
      await _storage.delete(key: "jwt");

  static Future deleteUsername() async =>
      await _storage.delete(key: "username");

  static Future deleteFirstName() async =>
      await _storage.delete(key: "firstName");

  static Future deleteLastName() async =>
      await _storage.delete(key: "lastName");
}