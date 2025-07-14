import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chefstation_multivendor/util/logger.dart';

class SecurityUtils {
  static const String _encryptionKey = 'your-32-char-secret-key-here!!'; // Change in production
  static const String _ivKey = 'your-16-char-iv!!'; // Change in production
  static const String _secureStoragePrefix = 'secure_';
  
  static late final encrypt.Encrypter _encrypter;
  static late final encrypt.IV _iv;
  
  /// Initialize encryption
  static void initialize() {
    try {
      final key = encrypt.Key.fromUtf8(_encryptionKey);
      _iv = encrypt.IV.fromUtf8(_ivKey);
      _encrypter = encrypt.Encrypter(encrypt.AES(key));
      AppLogger.info('Security utils initialized successfully');
    } catch (error) {
      AppLogger.error('Failed to initialize security utils', error);
    }
  }

  /// Encrypt sensitive data
  static String encryptData(String data) {
    try {
      final encrypted = _encrypter.encrypt(data, iv: _iv);
      return encrypted.base64;
    } catch (error) {
      AppLogger.error('Encryption failed', error);
      return data; // Fallback to plain text
    }
  }

  /// Decrypt sensitive data
  static String decryptData(String encryptedData) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (error) {
      AppLogger.error('Decryption failed', error);
      return encryptedData; // Return as-is if decryption fails
    }
  }

  /// Hash data using SHA-256
  static String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate secure random string
  static String generateSecureToken([int length = 32]) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  /// Generate secure random bytes
  static Uint8List generateSecureBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Store data securely (encrypted)
  static Future<bool> storeSecureData(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedValue = encryptData(value);
      final secureKey = _secureStoragePrefix + hashData(key);
      return await prefs.setString(secureKey, encryptedValue);
    } catch (error) {
      AppLogger.error('Failed to store secure data', error);
      return false;
    }
  }

  /// Retrieve data securely (decrypted)
  static Future<String?> getSecureData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final secureKey = _secureStoragePrefix + hashData(key);
      final encryptedValue = prefs.getString(secureKey);
      
      if (encryptedValue != null) {
        return decryptData(encryptedValue);
      }
      return null;
    } catch (error) {
      AppLogger.error('Failed to retrieve secure data', error);
      return null;
    }
  }

  /// Remove secure data
  static Future<bool> removeSecureData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final secureKey = _secureStoragePrefix + hashData(key);
      return await prefs.remove(secureKey);
    } catch (error) {
      AppLogger.error('Failed to remove secure data', error);
      return false;
    }
  }

  /// Clear all secure data
  static Future<bool> clearAllSecureData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final secureKeys = keys.where((key) => key.startsWith(_secureStoragePrefix));
      
      for (final key in secureKeys) {
        await prefs.remove(key);
      }
      
      AppLogger.info('All secure data cleared');
      return true;
    } catch (error) {
      AppLogger.error('Failed to clear secure data', error);
      return false;
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(
      r'^\+?[1-9]\d{1,14}$',
    );
    return phoneRegex.hasMatch(phone);
  }

  /// Validate password strength
  static PasswordStrength validatePasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    switch (score) {
      case 0:
      case 1:
        return PasswordStrength.veryWeak;
      case 2:
        return PasswordStrength.weak;
      case 3:
        return PasswordStrength.medium;
      case 4:
        return PasswordStrength.strong;
      case 5:
        return PasswordStrength.veryStrong;
      default:
        return PasswordStrength.veryWeak;
    }
  }

  /// Sanitize input data
  static String sanitizeInput(String input) {
    // Remove potentially dangerous characters
    return input
        .replaceAll(RegExp(r'[<>"\\]'), '')
        .trim();
  }

  /// Validate API response
  static bool isValidApiResponse(Map<String, dynamic> response) {
    // Check for required fields
    if (!response.containsKey('success')) return false;
    if (!response.containsKey('message')) return false;
    
    // Validate data types
    if (response['success'] is! bool) return false;
    if (response['message'] is! String) return false;
    
    return true;
  }

  /// Generate API signature for requests
  static String generateApiSignature(Map<String, dynamic> data, String secretKey) {
    // Sort keys for consistent signature
    final sortedKeys = data.keys.toList()..sort();
    final sortedData = <String, dynamic>{};
    
    for (final key in sortedKeys) {
      sortedData[key] = data[key];
    }
    
    // Create signature string
    final signatureString = jsonEncode(sortedData) + secretKey;
    return hashData(signatureString);
  }

  /// Verify API signature
  static bool verifyApiSignature(
    Map<String, dynamic> data,
    String signature,
    String secretKey,
  ) {
    final expectedSignature = generateApiSignature(data, secretKey);
    return signature == expectedSignature;
  }

  /// Mask sensitive data for logging
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars * 2) {
      return '*' * data.length;
    }
    
    final start = data.substring(0, visibleChars);
    final end = data.substring(data.length - visibleChars);
    final middle = '*' * (data.length - visibleChars * 2);
    
    return start + middle + end;
  }

  /// Generate secure session token
  static String generateSessionToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = generateSecureToken(16);
    final data = '$timestamp:$random';
    return encryptData(data);
  }

  /// Validate session token
  static bool isValidSessionToken(String token) {
    try {
      final decrypted = decryptData(token);
      final parts = decrypted.split(':');
      
      if (parts.length != 2) return false;
      
      final timestamp = int.tryParse(parts[0]);
      if (timestamp == null) return false;
      
      // Check if token is not older than 24 hours
      final tokenTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(tokenTime);
      
      return difference.inHours < 24;
    } catch (error) {
      AppLogger.error('Session token validation failed', error);
      return false;
    }
  }
}

enum PasswordStrength {
  veryWeak,
  weak,
  medium,
  strong,
  veryStrong,
}

/// Secure storage wrapper
class SecureStorage {
  static Future<bool> storeToken(String token) async {
    return await SecurityUtils.storeSecureData('auth_token', token);
  }

  static Future<String?> getToken() async {
    return await SecurityUtils.getSecureData('auth_token');
  }

  static Future<bool> removeToken() async {
    return await SecurityUtils.removeSecureData('auth_token');
  }

  static Future<bool> storeUserCredentials(String email, String password) async {
    final success1 = await SecurityUtils.storeSecureData('user_email', email);
    final success2 = await SecurityUtils.storeSecureData('user_password', password);
    return success1 && success2;
  }

  static Future<Map<String, String?>> getUserCredentials() async {
    final email = await SecurityUtils.getSecureData('user_email');
    final password = await SecurityUtils.getSecureData('user_password');
    return {'email': email, 'password': password};
  }

  static Future<bool> clearUserCredentials() async {
    final success1 = await SecurityUtils.removeSecureData('user_email');
    final success2 = await SecurityUtils.removeSecureData('user_password');
    return success1 && success2;
  }
} 