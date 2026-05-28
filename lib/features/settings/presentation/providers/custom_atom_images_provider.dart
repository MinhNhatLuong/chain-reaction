import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/features/settings/presentation/providers/settings_providers.dart';
import 'package:chain_reaction/features/shop/presentation/providers/shop_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int kCustomAtomImageSlotCount = 3;

class CustomAtomImagesState {
  const CustomAtomImagesState({required this.encodedImages});

  final List<String> encodedImages;

  List<Uint8List?> get images {
    return encodedImages
        .map((encoded) {
          if (encoded.isEmpty) return null;
          try {
            return base64Decode(encoded);
          } on FormatException {
            return null;
          }
        })
        .toList(growable: false);
  }

  bool get hasAnyImage => encodedImages.any((encoded) => encoded.isNotEmpty);

  Uint8List? imageAt(int index) {
    if (index < 0 || index >= encodedImages.length) return null;
    final encoded = encodedImages[index];
    if (encoded.isEmpty) return null;
    try {
      return base64Decode(encoded);
    } on FormatException {
      return null;
    }
  }

  CustomAtomImagesState copyWithSlot(int index, String encodedImage) {
    final nextImages = List<String>.from(encodedImages);
    nextImages[index] = encodedImage;
    return CustomAtomImagesState(encodedImages: nextImages);
  }
}

class CustomAtomImagesNotifier extends Notifier<CustomAtomImagesState> {
  static const String _keyCustomAtomImages = 'customAtomImages';

  @override
  CustomAtomImagesState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getStringList(_keyCustomAtomImages);
    final images = List<String>.filled(kCustomAtomImageSlotCount, '');

    if (stored != null) {
      for (var i = 0; i < images.length && i < stored.length; i++) {
        images[i] = stored[i];
      }
    }

    return CustomAtomImagesState(encodedImages: images);
  }

  Future<void> setImage(int index, Uint8List bytes) async {
    if (index < 0 || index >= kCustomAtomImageSlotCount) return;

    state = state.copyWithSlot(index, base64Encode(bytes));
    await _save();
  }

  Future<void> clearImage(int index) async {
    if (index < 0 || index >= kCustomAtomImageSlotCount) return;

    state = state.copyWithSlot(index, '');
    await _save();
  }

  Future<void> clearImages() async {
    state = const CustomAtomImagesState(
      encodedImages: ['', '', ''],
    );
    await _save();
  }

  Future<void> _save() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyCustomAtomImages, state.encodedImages);
  }
}

final customAtomImagesProvider =
    NotifierProvider<CustomAtomImagesNotifier, CustomAtomImagesState>(
      CustomAtomImagesNotifier.new,
    );

final photoOrbsOwnershipProvider = FutureProvider<bool>((ref) async {
  if (kDebugMode) return true;

  final repository = ref.watch(shopRepositoryProvider);
  return repository.isThemeOwned(AppThemes.photoOrbs.name);
});

final isCustomAtomImagesUnlockedProvider = Provider<bool>((ref) {
  final ownership = ref.watch(photoOrbsOwnershipProvider);
  return ownership.asData?.value ?? false;
});

final customAtomUiImagesProvider = FutureProvider<List<ui.Image?>?>((ref) {
  final isUnlocked = ref.watch(isCustomAtomImagesUnlockedProvider);
  final imageState = ref.watch(customAtomImagesProvider);

  if (!isUnlocked || !imageState.hasAnyImage) {
    return null;
  }

  return _decodeImages(imageState.images);
});

Future<List<ui.Image?>> _decodeImages(List<Uint8List?> bytesList) async {
  final images = <ui.Image?>[];

  for (final bytes in bytesList) {
    if (bytes == null) {
      images.add(null);
      continue;
    }

    images.add(await _decodeImage(bytes));
  }

  return images;
}

Future<ui.Image> _decodeImage(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}
