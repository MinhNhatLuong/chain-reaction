import 'dart:async';

import 'package:chain_reaction/features/settings/presentation/providers/settings_providers.dart';
import 'package:chain_reaction/features/shop/data/repositories/shop_repository_impl.dart';
import 'package:chain_reaction/features/shop/data/services/iap_service.dart';
import 'package:chain_reaction/features/shop/data/services/purchase_validation_service.dart';
import 'package:chain_reaction/features/shop/domain/entities/shop_event.dart';
import 'package:chain_reaction/features/shop/domain/repositories/shop_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_provider.freezed.dart';
part 'shop_provider.g.dart';

// Define your product IDs here.
// Note: These must match AppTheme.name exactly because the app uses name as ID.
// In a real app, you might map 'Earthy' -> 'chain_reaction_earthy'.
const String kCoffeeId = 'support_coffee';
const Set<String> kThemeIds = {'Earthy', 'Pastel', 'Amoled', 'Photo Orbs'};
const String _androidPublisherApiKey = String.fromEnvironment(
  'ANDROID_PUBLISHER_API_KEY',
);
const bool _allowLocalValidationFallback = bool.fromEnvironment(
  'ALLOW_LOCAL_IAP_VALIDATION_FALLBACK',
);

String? _nonEmptyOrNull(String value) => value.isEmpty ? null : value;

/// Provider for [ShopRepository].
@riverpod
ShopRepository shopRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ShopRepositoryImpl(prefs);
}

/// Provider for [IAPService].
/// This allows us to override the service in tests with a mock.
@riverpod
IAPService iapService(Ref ref) {
  final validationService = PurchaseValidationService(
    androidApiKey: _nonEmptyOrNull(_androidPublisherApiKey),
  );

  final service = IAPService(
    validationService: validationService,
    allowUnconfiguredValidationFallback:
        kDebugMode || _allowLocalValidationFallback,
  );
  ref.onDispose(service.dispose);
  return service;
}

@freezed
abstract class ShopState with _$ShopState {
  const factory ShopState({
    @Default([]) List<String> ownedThemeIds,
    @Default([]) List<ProductDetails> products,
  }) = _ShopState;
  const ShopState._();

  bool isOwned(String themeId) => ownedThemeIds.contains(themeId);

  ProductDetails? getProduct(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } on Object {
      return null;
    }
  }
}

@riverpod
class ShopNotifier extends _$ShopNotifier {
  late final ShopRepository _repository;
  late final IAPService _iapService;
  StreamSubscription<ShopEvent>? _eventSubscription;

  @override
  Future<ShopState> build() async {
    _repository = ref.watch(shopRepositoryProvider);
    _iapService = ref.watch(iapServiceProvider);

    // Listen to IAP events
    _eventSubscription = _iapService.events.listen(_onShopEvent);

    // Ensure subscription is cancelled when notifier is disposed
    ref.onDispose(() {
      unawaited(_eventSubscription?.cancel());
    });

    // Initialize IAP
    await _iapService.initialize();

    // Load initial data
    var ownedIds = await _repository.getPurchasedThemeIds();

    // In debug mode, unlock all themes for testing
    if (kDebugMode) {
      ownedIds = kThemeIds.toList();
    }

    var products = <ProductDetails>[];
    try {
      final allIds = {...kThemeIds, kCoffeeId};
      products = await _iapService.loadProducts(allIds);
    } on Object {
      // Products failed to load, but we can still show owned themes
      // We could also throw here to show error state in UI
      // but partial state is often better for UX (can still see owned stuff)
    }

    return ShopState(ownedThemeIds: ownedIds, products: products);
  }

  Future<void> purchaseTheme(ProductDetails product) async {
    state = const AsyncValue.loading();
    try {
      await _iapService.buyNonConsumable(product);
      // State updates via callbacks -> stream listener
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> buyCoffee(ProductDetails product) async {
    state = const AsyncValue.loading();
    try {
      await _iapService.buyConsumable(product);
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> restorePurchases() async {
    state = const AsyncValue.loading();
    try {
      await _iapService.restorePurchases();
      // Completion is handled via the purchase updates stream.
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _onShopEvent(ShopEvent event) {
    switch (event) {
      case PurchaseCompleted(:final productId):
        unawaited(_handlePurchaseCompleted(productId));
      case PurchaseError(:final message):
        _handlePurchaseError(message);
      case ValidationComplete(:final productId, :final isValid):
        _handleValidationComplete(productId, isValid);
    }
  }

  Future<void> _handlePurchaseCompleted(String productId) async {
    // Reload state to reflect changes
    // Reload owned IDs to reflect the new purchase.
    try {
      final currentProducts = state.value?.products ?? [];
      final ids = await _repository.getPurchasedThemeIds();

      state = AsyncValue.data(
        ShopState(ownedThemeIds: ids, products: currentProducts),
      );
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _handlePurchaseError(String error) {
    state = AsyncValue.error(error, StackTrace.current);
  }

  void _handleValidationComplete(String productId, bool isValid) {
    if (!isValid) {
      final currentState = state.asData?.value;
      if (currentState != null) {
        final updatedOwnedThemeIds = List<String>.from(
          currentState.ownedThemeIds,
        )..remove(productId);

        state = AsyncValue.data(
          currentState.copyWith(ownedThemeIds: updatedOwnedThemeIds),
        );
      }
    }
  }
}
