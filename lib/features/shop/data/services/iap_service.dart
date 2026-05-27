import 'dart:async';
import 'dart:developer';

import 'package:chain_reaction/features/shop/data/services/purchase_state_manager.dart';
import 'package:chain_reaction/features/shop/data/services/purchase_validation_service.dart';
import 'package:chain_reaction/features/shop/domain/entities/shop_event.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Service to handle In-App Purchases (IAP).
class IAPService {
  IAPService({
    InAppPurchase? iap,
    PurchaseStateManager? stateManager,
    PurchaseValidationService? validationService,
    bool allowUnconfiguredValidationFallback = false,
  }) : _iap = iap ?? InAppPurchase.instance,
       _stateManager = stateManager ?? PurchaseStateManager(),
       _validationService = validationService ?? PurchaseValidationService(),
       _allowUnconfiguredValidationFallback =
           allowUnconfiguredValidationFallback;
  final InAppPurchase _iap;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final PurchaseValidationService _validationService;
  final PurchaseStateManager _stateManager;
  final bool _allowUnconfiguredValidationFallback;

  final StreamController<ShopEvent> _eventController =
      StreamController<ShopEvent>.broadcast();

  Stream<ShopEvent> get events => _eventController.stream;

  /// Initialize the service and start listening to purchase updates.
  Future<void> initialize() async {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () {
        unawaited(_subscription.cancel());
      },
      onError: (Object error) {
        if (kDebugMode) {
          log('IAP Error: $error');
        }
        _eventController.add(ShopEvent.purchaseError(error.toString()));
      },
    );

    // Check for pending validations on startup
    await _checkPendingValidations();
  }

  void dispose() {
    unawaited(_subscription.cancel());
    unawaited(_eventController.close());
  }

  /// Load products from the store.
  Future<List<ProductDetails>> loadProducts(Set<String> ids) async {
    final available = await _iap.isAvailable();
    if (!available) {
      if (kDebugMode) {
        log('IAP Store not available');
      }
      return [];
    }

    final response = await _iap.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      if (kDebugMode) {
        log('IAP Products not found: ${response.notFoundIDs}');
      }
    }

    // Sort products by price if needed, or return as is
    return response.productDetails;
  }

  /// Purchase a non-consumable product (e.g., Theme).
  Future<void> buyNonConsumable(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Purchase a consumable product (e.g., "Buy me a coffee").
  Future<void> buyConsumable(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  /// Restore purchases (for non-consumables).
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Check for purchases that need validation
  Future<void> _checkPendingValidations() async {
    if (!await _stateManager.needsValidationCheck()) {
      return;
    }

    final allPurchases = await _stateManager.getAllPurchases();
    final now = DateTime.now();

    for (final purchase in allPurchases.values) {
      if (purchase.needsValidation) {
        await _validatePurchase(purchase.transactionId, purchase.productId);
      }
    }

    await _stateManager.setLastValidationCheck(now);
  }

  /// Validate a purchase and update its state
  Future<void> _validatePurchase(
    String transactionId,
    String productId, {
    PurchaseDetails? purchaseDetails,
  }) async {
    try {
      // Get the current purchase details
      final purchaseInfo = await _stateManager.getPurchase(transactionId);
      if (purchaseInfo == null) return;

      // Unconfigured backend is only allowed for local/dev fallback.
      if (!_validationService.isConfigured) {
        if (_allowUnconfiguredValidationFallback) {
          await _stateManager.updatePurchaseState(
            transactionId,
            PurchaseState.validated,
            validationDate: DateTime.now(),
          );
          _eventController.add(
            ShopEvent.validationComplete(productId, isValid: true),
          );
          return;
        }

        const errorMessage =
            'Purchase validation backend is not configured. '
            'Set Android validation credentials or enable local fallback.';
        await _stateManager.updatePurchaseState(
          transactionId,
          PurchaseState.failed,
          errorMessage: errorMessage,
        );
        _eventController
          ..add(const ShopEvent.purchaseError(errorMessage))
          ..add(ShopEvent.validationComplete(productId, isValid: false));
        return;
      }

      // Pending revalidation has no receipt payload in local storage.
      if (purchaseDetails == null) {
        if (kDebugMode) {
          log(
            'Skipping revalidation for $transactionId: missing purchase payload',
          );
        }
        return;
      }

      final validation = await _validationService.validatePurchase(
        purchaseDetails,
      );

      // Update purchase state based on validation
      switch (validation.result) {
        case ValidationResult.valid:
          await _stateManager.updatePurchaseState(
            transactionId,
            PurchaseState.validated,
            validationDate: validation.purchaseDate,
            expiryDate: validation.expiryDate,
          );
          _eventController.add(
            ShopEvent.validationComplete(productId, isValid: true),
          );
        case ValidationResult.invalid:
        case ValidationResult.expired:
        case ValidationResult.refunded:
        case ValidationResult.revoked:
        case ValidationResult.cancelled:
          await _stateManager.updatePurchaseState(
            transactionId,
            _mapValidationResultToPurchaseState(validation.result),
            errorMessage: validation.errorMessage,
          );
          _eventController.add(
            ShopEvent.validationComplete(productId, isValid: false),
          );
        case ValidationResult.pending:
          // Keep as pending
          break;
        case ValidationResult.error:
          await _stateManager.updatePurchaseState(
            transactionId,
            PurchaseState.failed,
            errorMessage: validation.errorMessage,
          );
          _eventController.add(
            ShopEvent.validationComplete(productId, isValid: false),
          );
      }
    } on Object catch (e) {
      if (kDebugMode) {
        log('Error validating purchase $transactionId: $e');
      }
    }
  }

  /// Map validation result to purchase state
  PurchaseState _mapValidationResultToPurchaseState(ValidationResult result) {
    switch (result) {
      case ValidationResult.valid:
        return PurchaseState.validated;
      case ValidationResult.pending:
        return PurchaseState.pending;
      case ValidationResult.expired:
        return PurchaseState.expired;
      case ValidationResult.refunded:
        return PurchaseState.refunded;
      case ValidationResult.revoked:
        return PurchaseState.revoked;
      case ValidationResult.cancelled:
        return PurchaseState.failed;
      case ValidationResult.invalid:
      case ValidationResult.error:
        return PurchaseState.failed;
    }
  }

  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      final transactionId = purchaseDetails.purchaseID ?? '';
      final productId = purchaseDetails.productID;

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Create pending purchase state
        final purchaseInfo = PurchaseInfo(
          productId: productId,
          transactionId: transactionId,
          state: PurchaseState.pending,
          purchaseDate: DateTime.now(),
        );
        await _stateManager.savePurchase(purchaseInfo);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Save failed purchase
          final purchaseInfo = PurchaseInfo(
            productId: productId,
            transactionId: transactionId,
            state: PurchaseState.failed,
            purchaseDate: DateTime.now(),
            errorMessage: purchaseDetails.error?.message ?? 'Unknown error',
          );
          await _stateManager.savePurchase(purchaseInfo);
          _eventController.add(
            ShopEvent.purchaseError(
              purchaseDetails.error?.message ?? 'Unknown error',
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Create purchased state
          final purchaseInfo = PurchaseInfo(
            productId: productId,
            transactionId: transactionId,
            state: PurchaseState.purchased,
            purchaseDate: DateTime.now(),
          );
          await _stateManager.savePurchase(purchaseInfo);

          // Validate the purchase
          await _validatePurchase(
            transactionId,
            productId,
            purchaseDetails: purchaseDetails,
          );

          // Check if purchase is still valid after validation
          final updatedPurchase = await _stateManager.getPurchase(
            transactionId,
          );
          if (updatedPurchase != null && updatedPurchase.isValid) {
            _eventController.add(ShopEvent.purchaseCompleted(productId));
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }
}
