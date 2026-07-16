import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chain_reaction/core/services/update/android_update_installer.dart';
import 'package:chain_reaction/core/services/update/update_release.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateService {
  UpdateService({
    http.Client? client,
    AndroidUpdateInstaller? installer,
  }) : _client = client ?? http.Client(),
       _installer = installer ?? AndroidUpdateInstaller();

  static final Uri _latestReleaseUri = Uri.parse(
    'https://api.github.com/repos/MinhNhatLuong/chain-reaction/releases/latest',
  );

  final http.Client _client;
  final AndroidUpdateInstaller _installer;

  Future<int> currentBuildNumber() async {
    final info = await PackageInfo.fromPlatform();
    return int.tryParse(info.buildNumber) ?? 0;
  }

  Future<UpdateAvailability?> checkForUpdate() async {
    final currentBuild = await currentBuildNumber();
    final url = _latestReleaseUri.replace(
      queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    final response = await _client.get(
      url,
      headers: const {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
        'Cache-Control': 'no-cache',
      },
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw const NoPublishedUpdateReleaseException();
      }

      throw UpdateException(
        'Could not check GitHub releases (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const UpdateException('GitHub release response was invalid.');
    }

    final release = UpdateRelease.fromJson(decoded);
    final latestBuild = release.buildNumber;
    if (latestBuild == null) {
      throw UpdateException(
        'Latest release tag "${release.tagName}" is not a build tag.',
      );
    }

    if (latestBuild <= currentBuild) return null;

    final supportedAbis = await _installer.getSupportedAbis();
    final apkAsset = selectAndroidApkAsset(release.assets, supportedAbis);
    if (apkAsset == null) {
      throw UpdateException(
        'No APK asset matches this device (${supportedAbis.join(', ')}).',
      );
    }

    return UpdateAvailability(
      currentBuildNumber: currentBuild,
      release: release,
      apkAsset: apkAsset,
    );
  }

  Future<bool> canRequestPackageInstalls() {
    return _installer.canRequestPackageInstalls();
  }

  Future<void> openInstallPermissionSettings() {
    return _installer.openInstallPermissionSettings();
  }

  Future<File> downloadAndVerifyApk({
    required UpdateAvailability availability,
    required void Function(double progress) onProgress,
  }) async {
    final asset = availability.apkAsset;
    final expectedSha256 = await _expectedSha256(availability, asset);
    final cacheDir = await getTemporaryDirectory();
    final updatesDir = Directory('${cacheDir.path}/updates');
    if (!updatesDir.existsSync()) {
      await updatesDir.create(recursive: true);
    }

    final apkFile = File('${updatesDir.path}/${asset.name}');
    final request = http.Request('GET', Uri.parse(asset.downloadUrl));
    final response = await _client.send(request);

    if (response.statusCode != 200) {
      throw UpdateException(
        'Could not download APK (${response.statusCode}).',
      );
    }

    final sink = apkFile.openWrite();
    var downloaded = 0;
    final responseLength = response.contentLength;
    final total = responseLength != null && responseLength > 0
        ? responseLength
        : asset.size;

    try {
      await for (final chunk in response.stream) {
        downloaded += chunk.length;
        sink.add(chunk);
        if (total > 0) {
          onProgress((downloaded / total).clamp(0, 1).toDouble());
        }
      }
    } finally {
      await sink.close();
    }

    final actualSha256 = await _sha256Of(apkFile);
    if (actualSha256 != expectedSha256) {
      try {
        await apkFile.delete();
      } on Object {
        // Keep the original checksum error; cleanup failure is secondary.
      }
      throw const UpdateException(
        'Downloaded APK checksum did not match the release checksum.',
      );
    }

    onProgress(1);
    return apkFile;
  }

  Future<void> installApk(File apkFile) {
    return _installer.installApk(apkFile.path);
  }

  Future<String> _expectedSha256(
    UpdateAvailability availability,
    UpdateAsset asset,
  ) async {
    final digest = asset.sha256Digest;
    if (digest != null && digest.isNotEmpty) {
      return digest.toLowerCase();
    }

    final checksumsAsset = availability.release.checksumsAsset;
    if (checksumsAsset == null) {
      throw const UpdateException('Release is missing checksums.txt.');
    }

    final response = await _client.get(Uri.parse(checksumsAsset.downloadUrl));
    if (response.statusCode != 200) {
      throw UpdateException(
        'Could not download checksums.txt (${response.statusCode}).',
      );
    }

    final checksums = parseSha256Checksums(response.body);
    final checksum = checksums[asset.name];
    if (checksum == null) {
      throw UpdateException('No checksum found for ${asset.name}.');
    }

    return checksum;
  }

  Future<String> _sha256Of(File file) async {
    return sha256.convert(await file.readAsBytes()).toString();
  }
}

class UpdateException implements Exception {
  const UpdateException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NoPublishedUpdateReleaseException extends UpdateException {
  const NoPublishedUpdateReleaseException()
    : super('No published update release found yet.');
}
