import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_event.freezed.dart';

@freezed
sealed class ShopEvent with _$ShopEvent {
  const factory ShopEvent.purchaseCompleted(String productId) =
      PurchaseCompleted;
  const factory ShopEvent.purchaseError(String message) = PurchaseError;
  const factory ShopEvent.validationComplete(
    String productId, {
    required bool isValid,
  }) = ValidationComplete;
}
