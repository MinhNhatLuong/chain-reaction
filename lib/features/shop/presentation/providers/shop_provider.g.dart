// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for [ShopRepository].

@ProviderFor(shopRepository)
const shopRepositoryProvider = ShopRepositoryProvider._();

/// Provider for [ShopRepository].

final class ShopRepositoryProvider
    extends $FunctionalProvider<ShopRepository, ShopRepository, ShopRepository>
    with $Provider<ShopRepository> {
  /// Provider for [ShopRepository].
  const ShopRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShopRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShopRepository create(Ref ref) {
    return shopRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShopRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShopRepository>(value),
    );
  }
}

String _$shopRepositoryHash() => r'f4650e6bdb86852a4e9b9fa144c5d5444d2026e3';

/// Provider for [IAPService].
/// This allows us to override the service in tests with a mock.

@ProviderFor(iapService)
const iapServiceProvider = IapServiceProvider._();

/// Provider for [IAPService].
/// This allows us to override the service in tests with a mock.

final class IapServiceProvider
    extends $FunctionalProvider<IAPService, IAPService, IAPService>
    with $Provider<IAPService> {
  /// Provider for [IAPService].
  /// This allows us to override the service in tests with a mock.
  const IapServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iapServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iapServiceHash();

  @$internal
  @override
  $ProviderElement<IAPService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAPService create(Ref ref) {
    return iapService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAPService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAPService>(value),
    );
  }
}

String _$iapServiceHash() => r'efa35b923b0e5d991c9220ccaa1d2fa60d68f055';

@ProviderFor(ShopNotifier)
const shopProvider = ShopNotifierProvider._();

final class ShopNotifierProvider
    extends $AsyncNotifierProvider<ShopNotifier, ShopState> {
  const ShopNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopNotifierHash();

  @$internal
  @override
  ShopNotifier create() => ShopNotifier();
}

String _$shopNotifierHash() => r'fc623f71cb5b4448aa1e54a69e7b6dd494d807d5';

abstract class _$ShopNotifier extends $AsyncNotifier<ShopState> {
  FutureOr<ShopState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ShopState>, ShopState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ShopState>, ShopState>,
              AsyncValue<ShopState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
