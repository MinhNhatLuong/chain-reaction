/// Repository for managing shop and entitlement data.
abstract interface class ShopRepository {
  /// Returns a list of all purchased theme IDs (names).
  Future<List<String>> getPurchasedThemeIds();

  /// Marks a theme as purchased.
  Future<void> purchaseTheme(String themeId);

  /// Checks if a specific theme is owned.
  Future<bool> isThemeOwned(String themeId);

  /// Clears all purchases (debug/restore).
  Future<void> clearPurchases();
}
