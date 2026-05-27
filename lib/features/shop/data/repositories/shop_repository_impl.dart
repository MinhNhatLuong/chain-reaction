import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/features/shop/data/services/purchase_state_manager.dart';
import 'package:chain_reaction/features/shop/domain/repositories/shop_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [ShopRepository] using [SharedPreferences] and purchase state management.
class ShopRepositoryImpl implements ShopRepository {
  ShopRepositoryImpl(this._prefs) {
    _stateManager = PurchaseStateManager();
  }
  final SharedPreferences _prefs;
  late final PurchaseStateManager _stateManager;
  static const String _keyPurchasedThemes = 'purchased_themes';

  @override
  Future<List<String>> getPurchasedThemeIds() async {
    // Get valid purchased themes from the purchase state manager
    final allPurchases = await _stateManager.getAllPurchases();
    final validThemeIds = <String>{};

    for (final purchase in allPurchases.values) {
      // Check if this is a theme purchase and it's valid
      if (purchase.isValid && _isThemeProduct(purchase.productId)) {
        validThemeIds.add(purchase.productId);
      }
    }

    // Also check legacy purchases for backward compatibility
    final legacyPurchases = _prefs.getStringList(_keyPurchasedThemes) ?? [];
    validThemeIds.addAll(legacyPurchases);

    return validThemeIds.toList();
  }

  @override
  Future<void> purchaseTheme(String themeId) async {
    // This method is now deprecated in favor of purchase state management
    // Keep for backward compatibility but also update state manager
    final purchased = await getPurchasedThemeIds();
    if (!purchased.contains(themeId)) {
      final updated = [...purchased, themeId];
      await _prefs.setStringList(_keyPurchasedThemes, updated);
    }
  }

  @override
  Future<bool> isThemeOwned(String themeId) async {
    // Check if theme is owned through valid purchase
    final validPurchases = await _stateManager.getValidPurchasesByProduct(
      themeId,
    );
    if (validPurchases.isNotEmpty) {
      return true;
    }

    // Check legacy purchases for backward compatibility
    final purchased = await getPurchasedThemeIds();
    return purchased.contains(themeId);
  }

  @override
  Future<void> clearPurchases() async {
    await _prefs.remove(_keyPurchasedThemes);
    await _stateManager.clearAllPurchases();
  }

  /// Check if a product ID is a theme product
  bool _isThemeProduct(String productId) {
    final themeIds = AppThemes.all
        .where((theme) => theme.isPremium)
        .map((theme) => theme.name)
        .toSet();
    return themeIds.contains(productId);
  }

  /// Sync legacy purchases with new purchase state system
  Future<void> syncLegacyPurchases() async {
    final legacyPurchases = _prefs.getStringList(_keyPurchasedThemes) ?? [];

    for (final themeId in legacyPurchases) {
      // Check if theme is already in the new system
      final validPurchases = await _stateManager.getValidPurchasesByProduct(
        themeId,
      );
      if (validPurchases.isEmpty) {
        // Create a purchase record for legacy theme
        final purchaseInfo = PurchaseInfo(
          productId: themeId,
          transactionId:
              'legacy_${themeId}_${DateTime.now().millisecondsSinceEpoch}',
          state: PurchaseState.validated,
          purchaseDate: DateTime.now(),
          validationDate: DateTime.now(),
          metadata: {'source': 'legacy_migration'},
        );
        await _stateManager.savePurchase(purchaseInfo);
      }
    }

    // Clean up legacy data after successful migration
    await _prefs.remove(_keyPurchasedThemes);
  }

  /// Clean up invalid purchases
  Future<void> cleanupInvalidPurchases() async {
    await _stateManager.cleanupInvalidPurchases();
  }
}
