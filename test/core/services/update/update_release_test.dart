import 'package:chain_reaction/core/services/update/update_release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseBuildNumberTag', () {
    test('parses build tags', () {
      expect(parseBuildNumberTag('build-123'), 123);
    });

    test('rejects non-build tags', () {
      expect(parseBuildNumberTag('v1.2.3'), isNull);
      expect(parseBuildNumberTag('build-latest'), isNull);
    });
  });

  group('selectAndroidApkAsset', () {
    const assets = [
      UpdateAsset(
        name: 'chain_reaction_android_arm.apk',
        downloadUrl: 'https://example.com/arm.apk',
        size: 1,
      ),
      UpdateAsset(
        name: 'chain_reaction_android_arm64.apk',
        downloadUrl: 'https://example.com/arm64.apk',
        size: 2,
      ),
      UpdateAsset(
        name: 'chain_reaction_android_x64.apk',
        downloadUrl: 'https://example.com/x64.apk',
        size: 3,
      ),
    ];

    test('prefers arm64 when available', () {
      final asset = selectAndroidApkAsset(
        assets,
        ['arm64-v8a', 'armeabi-v7a'],
      );

      expect(asset?.name, 'chain_reaction_android_arm64.apk');
    });

    test('falls back to armeabi-v7a', () {
      final asset = selectAndroidApkAsset(assets, ['armeabi-v7a']);

      expect(asset?.name, 'chain_reaction_android_arm.apk');
    });

    test('selects x86_64 APK', () {
      final asset = selectAndroidApkAsset(assets, ['x86_64']);

      expect(asset?.name, 'chain_reaction_android_x64.apk');
    });

    test('returns null for unsupported ABI', () {
      final asset = selectAndroidApkAsset(assets, ['riscv64']);

      expect(asset, isNull);
    });
  });

  group('parseSha256Checksums', () {
    test('parses common sha256sum output', () {
      final checksums = parseSha256Checksums('''
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  chain_reaction_android_arm.apk
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB *chain_reaction_android_arm64.apk
''');

      expect(
        checksums['chain_reaction_android_arm.apk'],
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      );
      expect(
        checksums['chain_reaction_android_arm64.apk'],
        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
      );
    });
  });
}
