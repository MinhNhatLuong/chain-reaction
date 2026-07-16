import 'dart:convert';
import 'dart:io';
import 'package:chain_reaction/core/services/update/android_update_installer.dart';
import 'package:chain_reaction/core/services/update/update_release.dart';
import 'package:chain_reaction/core/services/update/update_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAndroidUpdateInstaller extends Fake implements AndroidUpdateInstaller {
  MockAndroidUpdateInstaller({this.abis = const ['arm64-v8a']});

  final List<String> abis;

  @override
  bool get isAndroid => true;

  @override
  Future<List<String>> getSupportedAbis() async {
    return abis;
  }
}

class MockPathProviderPlatform extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getTemporaryPath() async {
    return './tmp_test_dir';
  }
}

void main() {
  setUpAll(() {
    PackageInfo.setMockInitialValues(
      appName: 'Chain Reaction',
      packageName: 'com.example.chain_reaction',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: 'signature',
    );
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  tearDownAll(() {
    final dir = Directory('./tmp_test_dir');
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });

  group('UpdateService.checkForUpdate', () {
    test('returns null when build is up to date', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'tag_name': 'build-1',
            'assets': [
              {
                'name': 'chain_reaction_android_arm64.apk',
                'browser_download_url': 'https://example.com/arm64.apk',
                'size': 100,
              }
            ],
          }),
          200,
        );
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      final result = await service.checkForUpdate();
      expect(result, isNull);
    });

    test('returns UpdateAvailability when a new update is available', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'tag_name': 'build-17',
            'assets': [
              {
                'name': 'chain_reaction_android_arm64.apk',
                'browser_download_url': 'https://example.com/arm64.apk',
                'size': 100,
              }
            ],
          }),
          200,
        );
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      final result = await service.checkForUpdate();
      expect(result, isNotNull);
      expect(result!.release.buildNumber, 17);
      expect(result.apkAsset.name, 'chain_reaction_android_arm64.apk');
    });

    test('throws NoPublishedUpdateReleaseException on 404', () async {
      final client = MockClient((request) async {
        return http.Response('', 404);
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      expect(
        service.checkForUpdate,
        throwsA(isA<NoPublishedUpdateReleaseException>()),
      );
    });

    test('throws UpdateException on non-200 non-404 status codes', () async {
      final client = MockClient((request) async {
        return http.Response('', 500);
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      expect(
        service.checkForUpdate,
        throwsA(isA<UpdateException>()),
      );
    });

    test('throws UpdateException when latest release tag is not a build tag', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'tag_name': 'v1.2.3',
            'assets': <dynamic>[],
          }),
          200,
        );
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      expect(
        service.checkForUpdate,
        throwsA(isA<UpdateException>()),
      );
    });

    test('throws UpdateException when no APK matches device architecture', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'tag_name': 'build-17',
            'assets': [
              {
                'name': 'chain_reaction_android_x64.apk',
                'browser_download_url': 'https://example.com/x64.apk',
                'size': 100,
              }
            ],
          }),
          200,
        );
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(abis: const <String>['riscv64']),
      );

      expect(
        service.checkForUpdate,
        throwsA(isA<UpdateException>()),
      );
    });

    test('integration test with real GitHub API', () async {
      final client = http.Client();
      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      try {
        final result = await service.checkForUpdate();
        expect(result, isNotNull);
        expect(result!.release.buildNumber, greaterThan(0));
        expect(result.apkAsset.name, isNotEmpty);
      } finally {
        client.close();
      }
    });
  });

  group('UpdateService.downloadAndVerifyApk', () {
    test('downloads and verifies successfully when checksum matches', () async {
      final client = MockClient((request) async {
        if (request.url.toString().contains('/arm64.apk')) {
          return http.Response('hello', 200);
        }
        return http.Response('', 404);
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      const availability = UpdateAvailability(
        currentBuildNumber: 1,
        release: UpdateRelease(
          tagName: 'build-17',
          buildNumber: 17,
          name: 'Build 17',
          body: '',
          assets: [],
        ),
        apkAsset: UpdateAsset(
          name: 'chain_reaction_android_arm64.apk',
          downloadUrl: 'https://example.com/arm64.apk',
          size: 5,
          sha256Digest: '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
        ),
      );

      var progressCalled = false;
      final file = await service.downloadAndVerifyApk(
        availability: availability,
        onProgress: (p) {
          progressCalled = true;
        },
      );

      expect(file.existsSync(), isTrue);
      expect(await file.readAsString(), 'hello');
      expect(progressCalled, isTrue);
    });

    test('throws UpdateException and deletes file when checksum mismatch', () async {
      final client = MockClient((request) async {
        if (request.url.toString().contains('/arm64.apk')) {
          return http.Response('wrong_content', 200);
        }
        return http.Response('', 404);
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      const availability = UpdateAvailability(
        currentBuildNumber: 1,
        release: UpdateRelease(
          tagName: 'build-17',
          buildNumber: 17,
          name: 'Build 17',
          body: '',
          assets: [],
        ),
        apkAsset: UpdateAsset(
          name: 'chain_reaction_android_arm64.apk',
          downloadUrl: 'https://example.com/arm64.apk',
          size: 5,
          sha256Digest: '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
        ),
      );

      try {
        await service.downloadAndVerifyApk(
          availability: availability,
          onProgress: (p) {},
        );
        fail('Should have thrown UpdateException');
      } on UpdateException catch (e) {
        expect(e.message, contains('checksum did not match'));
      }

      final file = File('./tmp_test_dir/updates/chain_reaction_android_arm64.apk');
      expect(file.existsSync(), isFalse);
    });

    test('fetches checksums.txt when digest is not in asset', () async {
      final client = MockClient((request) async {
        if (request.url.toString().contains('/arm64.apk')) {
          return http.Response('hello', 200);
        } else if (request.url.toString().contains('/checksums.txt')) {
          return http.Response(
            '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824  chain_reaction_android_arm64.apk',
            200,
          );
        }
        return http.Response('', 404);
      });

      final service = UpdateService(
        client: client,
        installer: MockAndroidUpdateInstaller(),
      );

      const availability = UpdateAvailability(
        currentBuildNumber: 1,
        release: UpdateRelease(
          tagName: 'build-17',
          buildNumber: 17,
          name: 'Build 17',
          body: '',
          assets: [
            UpdateAsset(
              name: 'checksums.txt',
              downloadUrl: 'https://example.com/checksums.txt',
              size: 50,
            ),
          ],
        ),
        apkAsset: UpdateAsset(
          name: 'chain_reaction_android_arm64.apk',
          downloadUrl: 'https://example.com/arm64.apk',
          size: 5,
        ),
      );

      final file = await service.downloadAndVerifyApk(
        availability: availability,
        onProgress: (p) {},
      );

      expect(file.existsSync(), isTrue);
      expect(await file.readAsString(), 'hello');
    });
  });
}
