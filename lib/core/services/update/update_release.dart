class UpdateAsset {
  const UpdateAsset({
    required this.name,
    required this.downloadUrl,
    required this.size,
    this.sha256Digest,
  });

  factory UpdateAsset.fromJson(Map<String, dynamic> json) {
    final digest = json['digest'] as String?;
    return UpdateAsset(
      name: json['name'] as String? ?? '',
      downloadUrl: json['browser_download_url'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      sha256Digest: digest != null && digest.startsWith('sha256:')
          ? digest.substring('sha256:'.length)
          : null,
    );
  }

  final String name;
  final String downloadUrl;
  final int size;
  final String? sha256Digest;
}

class UpdateRelease {
  const UpdateRelease({
    required this.tagName,
    required this.buildNumber,
    required this.name,
    required this.body,
    required this.assets,
  });

  factory UpdateRelease.fromJson(Map<String, dynamic> json) {
    final tagName = json['tag_name'] as String? ?? '';
    final assetsJson = json['assets'] as List<dynamic>? ?? [];
    return UpdateRelease(
      tagName: tagName,
      buildNumber: parseBuildNumberTag(tagName),
      name: json['name'] as String? ?? tagName,
      body: json['body'] as String? ?? '',
      assets: assetsJson
          .whereType<Map<String, dynamic>>()
          .map(UpdateAsset.fromJson)
          .toList(growable: false),
    );
  }

  final String tagName;
  final int? buildNumber;
  final String name;
  final String body;
  final List<UpdateAsset> assets;

  UpdateAsset? get checksumsAsset {
    for (final asset in assets) {
      if (asset.name == 'checksums.txt') return asset;
    }
    return null;
  }
}

class UpdateAvailability {
  const UpdateAvailability({
    required this.currentBuildNumber,
    required this.release,
    required this.apkAsset,
  });

  final int currentBuildNumber;
  final UpdateRelease release;
  final UpdateAsset apkAsset;
}

int? parseBuildNumberTag(String tagName) {
  final match = RegExp(r'^build-(\d+)$').firstMatch(tagName.trim());
  if (match == null) return null;
  return int.tryParse(match.group(1)!);
}

String? preferredApkNameForAbis(List<String> supportedAbis) {
  const apkByAbi = <String, String>{
    'arm64-v8a': 'chain_reaction_android_arm64.apk',
    'armeabi-v7a': 'chain_reaction_android_arm.apk',
    'x86_64': 'chain_reaction_android_x64.apk',
  };

  for (final abi in supportedAbis) {
    final apkName = apkByAbi[abi];
    if (apkName != null) return apkName;
  }
  return null;
}

UpdateAsset? selectAndroidApkAsset(
  List<UpdateAsset> assets,
  List<String> supportedAbis,
) {
  final preferredName = preferredApkNameForAbis(supportedAbis);
  if (preferredName == null) return null;

  for (final asset in assets) {
    if (asset.name == preferredName) return asset;
  }
  return null;
}

Map<String, String> parseSha256Checksums(String content) {
  final checksums = <String, String>{};

  for (final rawLine in content.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;

    final match = RegExp(
      r'^([a-fA-F0-9]{64})\s+\*?(.+)$',
    ).firstMatch(line);
    if (match == null) continue;

    checksums[match.group(2)!.trim()] = match.group(1)!.toLowerCase();
  }

  return checksums;
}
