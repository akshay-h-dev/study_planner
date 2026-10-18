
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Result of an authentication operation.
enum AuthResult {
  success,
  invalidInput,
  emailAlreadyExists,
  invalidCredentials,
  storageError,
}

/// Local authentication service for the capstone demonstration.
///
/// IMPORTANT:
/// SharedPreferences is not a secure authentication database.
/// Use a real authentication backend for production applications.
class AuthService {
  static const String _usersKey = 'study_planner_users_v1';

  // Read saved accounts from local storage.
  Future<List<Map<String, dynamic>>> _readUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw const FormatException('Invalid saved account data.');
    }

    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('Invalid account record.');
      }
      return Map<String, dynamic>.from(item);
    }).toList();
  }

  // Save all account records.
  Future<void> _writeUsers(
    List<Map<String, dynamic>> users,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      _usersKey,
      jsonEncode(users),
    );

    if (!saved) {
      throw StateError('Unable to save account data.');
    }
  }

  // Store a digest instead of the original password.
  // This simple digest is for coursework only, not production security.
  String _passwordDigest(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Register a new account.
  Future<AuthResult> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    if (fullName.trim().isEmpty ||
        username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {
      return AuthResult.invalidInput;
    }

    try {
      final users = await _readUsers();
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedUsername = username.trim().toLowerCase();

      final alreadyExists = users.any((user) {
        return user['email'] == normalizedEmail ||
            user['username'] == normalizedUsername;
      });

      if (alreadyExists) {
        return AuthResult.emailAlreadyExists;
      }

      users.add({
        'fullName': fullName.trim(),
        'username': username.trim(),
        'email': normalizedEmail,
        'passwordDigest': _passwordDigest(password),
      });

      await _writeUsers(users);
      return AuthResult.success;
    } catch (_) {
      return AuthResult.storageError;
    }
  }

  // Verify credentials against locally saved account records.
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return AuthResult.invalidInput;
    }

    try {
      final users = await _readUsers();
      final normalizedEmail = email.trim().toLowerCase();
      final digest = _passwordDigest(password);

      final userExists = users.any((user) {
        return user['email'] == normalizedEmail &&
            user['passwordDigest'] == digest;
      });

      return userExists
          ? AuthResult.success
          : AuthResult.invalidCredentials;
    } catch (_) {
      return AuthResult.storageError;
    }
  }

  // Return the saved profile for use after login.
  Future<Map<String, dynamic>?> findUser(String email) async {
    try {
      final users = await _readUsers();
      final normalizedEmail = email.trim().toLowerCase();

      for (final user in users) {
        if (user['email'] == normalizedEmail) {
          return user;
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
