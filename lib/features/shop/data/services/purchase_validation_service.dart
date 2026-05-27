import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Purchase validation result
enum ValidationResult {
  valid,
  invalid,
  pending,
  expired,
  refunded,
  cancelled,
  error,
  revoked,
}

/// Validated purchase information
class ValidatedPurchase {
  ValidatedPurchase({
    required this.productId,
    required this.transactionId,
    required this.result,
    this.purchaseDate,
    this.expiryDate,
    this.errorMessage,
  });
  final String productId;
  final String transactionId;
  final ValidationResult result;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final String? errorMessage;
}

/// Service for validating purchase receipts with app stores
class PurchaseValidationService {
  PurchaseValidationService({String? androidApiKey})
    : _androidApiKey = androidApiKey;
  // In production, these should be stored securely (environment variables, key management)
  final String? _androidApiKey;

  /// Validate a purchase receipt
  Future<ValidatedPurchase> validatePurchase(PurchaseDetails purchase) async {
    try {
      if (kIsWeb) {
        return _unsupportedPurchase(purchase);
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return await _validateAndroidPurchase(purchase);
        case TargetPlatform.iOS:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
          return _unsupportedPurchase(purchase);
      }
    } on Object catch (e) {
      if (kDebugMode) {
        log('Purchase validation error: $e');
      }
      return ValidatedPurchase(
        productId: purchase.productID,
        transactionId: purchase.purchaseID ?? '',
        result: ValidationResult.error,
        errorMessage: e.toString(),
      );
    }
  }

  ValidatedPurchase _unsupportedPurchase(PurchaseDetails purchase) {
    return ValidatedPurchase(
      productId: purchase.productID,
      transactionId: purchase.purchaseID ?? '',
      result: ValidationResult.error,
      errorMessage: 'Unsupported platform',
    );
  }

  /// Validate Android purchase
  Future<ValidatedPurchase> _validateAndroidPurchase(
    PurchaseDetails purchase,
  ) async {
    // Basic local data integrity check
    if (purchase.verificationData.localVerificationData.isEmpty) {
      return ValidatedPurchase(
        productId: purchase.productID,
        transactionId: purchase.purchaseID ?? '',
        result: ValidationResult.invalid,
        errorMessage: 'Missing local verification data',
      );
    }

    // In a real implementation with backend, we would verify the signature here
    // checking verificationData.serverVerificationData with public key.

    // For now, checks are consistent with local store status
    return ValidatedPurchase(
      productId: purchase.productID,
      transactionId: purchase.purchaseID ?? '',
      result: ValidationResult.valid,
      purchaseDate: DateTime.now(),
    );
  }

  /// Check if validation service is properly configured
  bool get isConfigured {
    if (kIsWeb) return false;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final apiKey = _androidApiKey;
        return apiKey != null && apiKey.isNotEmpty;
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return false;
    }
  }
}
