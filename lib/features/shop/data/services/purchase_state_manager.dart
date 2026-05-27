import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Purchase state for tracking individual purchases
enum PurchaseState {
  pending,
  purchased,
  validated,
  failed,
  refunded,
  expired,
  revoked,
}

/// Purchase information with state tracking
class PurchaseInfo {
  PurchaseInfo({
    required this.productId,
    required this.transactionId,
    required this.state,
    required this.purchaseDate,
    this.validationDate,
    this.expiryDate,
    this.errorMessage,
    this.metadata,
  });

  /// Create from JSON
  factory PurchaseInfo.fromJson(Map<String, dynamic> json) {
    return PurchaseInfo(
      productId: json['productId'] as String,
      transactionId: json['transactionId'] as String,
      state: _parsePurchaseState(json['state'] as String),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      validationDate: json['validationDate'] != null
          ? DateTime.parse(json['validationDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      errorMessage: json['errorMessage'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
  final String productId;
  final String transactionId;
  final PurchaseState state;
  final DateTime purchaseDate;
  final DateTime? validationDate;
  final DateTime? expiryDate;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'transactionId': transactionId,
      'state': state.toString(),
      'purchaseDate': purchaseDate.toIso8601String(),
      'validationDate': validationDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
  }

  static PurchaseState _parsePurchaseState(String stateString) {
    for (final state in PurchaseState.values) {
      if (state.toString() == stateString) {
        return state;
      }
    }
    return PurchaseState.failed;
  }

  /// Create a copy with updated state
  PurchaseInfo copyWith({
    PurchaseState? state,
    DateTime? validationDate,
    DateTime? expiryDate,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return PurchaseInfo(
      productId: productId,
      transactionId: transactionId,
      state: state ?? this.state,
      purchaseDate: purchaseDate,
      validationDate: validationDate ?? this.validationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if purchase is still valid
  bool get isValid {
    switch (state) {
      case PurchaseState.purchased:
      case PurchaseState.validated:
        // Check if expired
        if (expiryDate != null && DateTime.now().isAfter(expiryDate!)) {
          return false;
        }
        return true;
      case PurchaseState.pending:
      case PurchaseState.failed:
      case PurchaseState.refunded:
      case PurchaseState.expired:
      case PurchaseState.revoked:
        return false;
    }
  }

  /// Check if purchase needs validation
  bool get needsValidation {
    return state == PurchaseState.purchased && validationDate == null;
  }
}

/// Service for managing purchase state persistence
class PurchaseStateManager {
  PurchaseStateManager({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();
  static const String _keyPurchases = 'purchase_states';
  static const String _keyLastValidation = 'last_validation_check';

  final FlutterSecureStorage _storage;

  /// Save purchase information
  Future<void> savePurchase(PurchaseInfo purchase) async {
    final purchases = await getAllPurchases();
    purchases[purchase.transactionId] = purchase;

    final purchasesJson = purchases.map(
      (key, value) => MapEntry(key, value.toJson()),
    );

    await _storage.write(key: _keyPurchases, value: jsonEncode(purchasesJson));

    if (kDebugMode) {
      log('Saved purchase: ${purchase.productId} - ${purchase.state}');
    }
  }

  /// Get all purchases
  Future<Map<String, PurchaseInfo>> getAllPurchases() async {
    final purchasesJson = await _storage.read(key: _keyPurchases);
    if (purchasesJson == null) {
      return {};
    }

    try {
      final data = jsonDecode(purchasesJson) as Map<String, dynamic>;
      final purchases = <String, PurchaseInfo>{};

      for (final entry in data.entries) {
        purchases[entry.key] = PurchaseInfo.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }

      return purchases;
    } on Object catch (e) {
      if (kDebugMode) {
        log('Error loading purchases: $e');
      }
      return {};
    }
  }

  /// Get purchase by transaction ID
  Future<PurchaseInfo?> getPurchase(String transactionId) async {
    final purchases = await getAllPurchases();
    return purchases[transactionId];
  }

  /// Get purchases by product ID
  Future<List<PurchaseInfo>> getPurchasesByProduct(String productId) async {
    final purchases = await getAllPurchases();
    return purchases.values
        .where((purchase) => purchase.productId == productId)
        .toList();
  }

  /// Get valid purchases for a product
  Future<List<PurchaseInfo>> getValidPurchasesByProduct(
    String productId,
  ) async {
    final purchases = await getPurchasesByProduct(productId);
    return purchases.where((purchase) => purchase.isValid).toList();
  }

  /// Update purchase state
  Future<void> updatePurchaseState(
    String transactionId,
    PurchaseState newState, {
    DateTime? validationDate,
    DateTime? expiryDate,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) async {
    final purchase = await getPurchase(transactionId);
    if (purchase != null) {
      final updatedPurchase = purchase.copyWith(
        state: newState,
        validationDate: validationDate,
        expiryDate: expiryDate,
        errorMessage: errorMessage,
        metadata: metadata,
      );
      await savePurchase(updatedPurchase);
    }
  }

  /// Remove purchase (for cleanup)
  Future<void> removePurchase(String transactionId) async {
    final purchases = await getAllPurchases();
    purchases.remove(transactionId);

    final purchasesJson = purchases.map(
      (key, value) => MapEntry(key, value.toJson()),
    );

    await _storage.write(key: _keyPurchases, value: jsonEncode(purchasesJson));
  }

  /// Clean up old/invalid purchases
  Future<void> cleanupInvalidPurchases() async {
    final purchases = await getAllPurchases();
    final now = DateTime.now();

    final validPurchases = <String, PurchaseInfo>{};
    for (final entry in purchases.entries) {
      final purchase = entry.value;

      // Keep if valid or if recent (within 30 days)
      if (purchase.isValid ||
          now.difference(purchase.purchaseDate).inDays < 30) {
        validPurchases[entry.key] = purchase;
      }
    }

    final purchasesJson = validPurchases.map(
      (key, value) => MapEntry(key, value.toJson()),
    );

    await _storage.write(key: _keyPurchases, value: jsonEncode(purchasesJson));

    if (kDebugMode) {
      log(
        'Cleaned up '
        '${purchases.length - validPurchases.length} invalid purchases',
      );
    }
  }

  /// Get last validation check time
  Future<DateTime?> getLastValidationCheck() async {
    final timestamp = await _storage.read(key: _keyLastValidation);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  /// Set last validation check time
  Future<void> setLastValidationCheck(DateTime time) async {
    await _storage.write(
      key: _keyLastValidation,
      value: time.toIso8601String(),
    );
  }

  /// Check if validation is needed (hasn't been checked recently)
  Future<bool> needsValidationCheck() async {
    final lastCheck = await getLastValidationCheck();
    if (lastCheck == null) return true;

    // Check if more than 24 hours have passed
    return DateTime.now().difference(lastCheck).inHours > 24;
  }

  /// Clear all purchase data (for testing/debug)
  Future<void> clearAllPurchases() async {
    await _storage.delete(key: _keyPurchases);
    await _storage.delete(key: _keyLastValidation);
  }
}
