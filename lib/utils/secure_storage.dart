import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // Stores token in secure storage
  static Future setToken(String token) async =>
      await _storage.write(key: "jwt", value: token);

  // Stores username in secure storage
  static Future setUsername(String username) async =>
      await _storage.write(key: "username", value: username);

  // Stores first name in secure storage
  static Future setFirstName(String firstName) async =>
      await _storage.write(key: "firstName", value: firstName);

  // Stores last name in secure storage
  static Future setLastName(String lastName) async =>
      await _storage.write(key: "lastName", value: lastName);

  // Gets the token in the secure storage
  static Future<String?> getToken() async {
    final jwt = await _storage.read(key: "jwt");

    return jwt;
  }

  // Gets the username in the secure storage
  static Future<String?> getUsername() async {
    final username = await _storage.read(key: "username");

    return username;
  }

  // Gets the first name in the secure storage
  static Future<String?> getFirstName() async {
    final firstName = await _storage.read(key: "firstName");

    return firstName;
  }

  // Gets the last name in the secure storage
  static Future<String?> getLastName() async {
    final lastName = await _storage.read(key: "lastName");

    return lastName;
  }

  // Deletes the token in the secure storage
  static Future deleteToken() async =>
      await _storage.delete(key: "jwt");

  // Deletes the username in the secure storage
  static Future deleteUsername() async =>
      await _storage.delete(key: "username");

  // Deletes the first name in the secure storage
  static Future deleteFirstName() async =>
      await _storage.delete(key: "firstName");

  // Deletes the last name in the secure storage
  static Future deleteLastName() async =>
      await _storage.delete(key: "lastName");
}