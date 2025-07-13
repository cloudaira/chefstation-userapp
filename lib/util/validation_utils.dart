import 'package:flutter/material.dart';
import 'package:chefstation_multivendor/util/security_utils.dart';

class ValidationUtils {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!SecurityUtils.isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    if (!SecurityUtils.isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }

  /// Minimum length validation
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    
    return null;
  }

  /// Maximum length validation
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be no more than $maxLength characters long';
    }
    
    return null;
  }

  /// Numeric validation
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    
    return null;
  }

  /// Integer validation
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (int.tryParse(value) == null) {
      return '$fieldName must be a valid integer';
    }
    
    return null;
  }

  /// URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  /// Credit card validation (Luhn algorithm)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    
    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-]'), '');
    
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return 'Credit card number must be between 13 and 19 digits';
    }
    
    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    if (sum % 10 != 0) {
      return 'Invalid credit card number';
    }
    
    return null;
  }

  /// Date validation
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Please enter a valid date';
    }
    
    return null;
  }

  /// Future date validation
  static String? validateFutureDate(String? value, String fieldName) {
    final dateError = validateDate(value, fieldName);
    if (dateError != null) return dateError;
    
    final date = DateTime.parse(value!);
    final now = DateTime.now();
    
    if (date.isBefore(now)) {
      return '$fieldName must be a future date';
    }
    
    return null;
  }

  /// Age validation
  static String? validateAge(String? value, int minAge, int maxAge) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < minAge || age > maxAge) {
      return 'Age must be between $minAge and $maxAge';
    }
    
    return null;
  }

  /// File size validation
  static String? validateFileSize(int fileSizeBytes, int maxSizeMB) {
    final maxSizeBytes = maxSizeMB * 1024 * 1024;
    
    if (fileSizeBytes > maxSizeBytes) {
      return 'File size must be less than ${maxSizeMB}MB';
    }
    
    return null;
  }

  /// File type validation
  static String? validateFileType(String fileName, List<String> allowedExtensions) {
    final extension = fileName.split('.').last.toLowerCase();
    
    if (!allowedExtensions.contains(extension)) {
      return 'File type not allowed. Allowed types: ${allowedExtensions.join(', ')}';
    }
    
    return null;
  }

  /// Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 10) {
      return 'Address must be at least 10 characters long';
    }
    
    return null;
  }

  /// Postal code validation
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    
    // Basic postal code validation (5 digits)
    final postalCodeRegex = RegExp(r'^\d{5}$');
    
    if (!postalCodeRegex.hasMatch(value)) {
      return 'Please enter a valid postal code';
    }
    
    return null;
  }

  /// Form validation helper
  static bool validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState == null) return false;
    return formKey.currentState!.validate();
  }

  /// Save form helper
  static void saveForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.save();
  }

  /// Reset form helper
  static void resetForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.reset();
  }

  /// Validate multiple fields
  static Map<String, String?> validateFields(Map<String, String?> fields) {
    final errors = <String, String?>{};
    
    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final value = entry.value;
      
      // Apply appropriate validation based on field name
      switch (fieldName.toLowerCase()) {
        case 'email':
          errors[fieldName] = validateEmail(value);
          break;
        case 'phone':
        case 'phonenumber':
          errors[fieldName] = validatePhone(value);
          break;
        case 'password':
          errors[fieldName] = validatePassword(value);
          break;
        case 'url':
          errors[fieldName] = validateUrl(value);
          break;
        case 'address':
          errors[fieldName] = validateAddress(value);
          break;
        case 'postalcode':
        case 'zipcode':
          errors[fieldName] = validatePostalCode(value);
          break;
        default:
          errors[fieldName] = validateRequired(value, fieldName);
      }
    }
    
    return errors;
  }

  /// Check if form has errors
  static bool hasErrors(Map<String, String?> errors) {
    return errors.values.any((error) => error != null);
  }

  /// Get first error message
  static String? getFirstError(Map<String, String?> errors) {
    for (final error in errors.values) {
      if (error != null) return error;
    }
    return null;
  }

  /// Sanitize form data
  static Map<String, String> sanitizeFormData(Map<String, String> data) {
    final sanitized = <String, String>{};
    
    for (final entry in data.entries) {
      sanitized[entry.key] = SecurityUtils.sanitizeInput(entry.value);
    }
    
    return sanitized;
  }
}

/// Form field validator mixin
mixin FormValidatorMixin {
  final Map<String, String?> _errors = {};
  
  Map<String, String?> get errors => _errors;
  
  void setError(String field, String? error) {
    _errors[field] = error;
  }
  
  void clearError(String field) {
    _errors.remove(field);
  }
  
  void clearAllErrors() {
    _errors.clear();
  }
  
  bool get hasErrors => _errors.values.any((error) => error != null);
  
  String? getFirstError() {
    for (final error in _errors.values) {
      if (error != null) return error;
    }
    return null;
  }
  
  bool validateField(String field, String? value, String? Function(String?) validator) {
    final error = validator(value);
    setError(field, error);
    return error == null;
  }
} 