import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AndroidUpdateInstaller {
  AndroidUpdateInstaller({
    MethodChannel channel = const MethodChannel(_channelName),
  }) : _channel = channel;

  static const String _channelName = 'chain_reaction/update_installer';
  final MethodChannel _channel;

  bool get isAndroid {
    return !kIsWeb && Platform.isAndroid;
  }

  Future<List<String>> getSupportedAbis() async {
    if (!isAndroid) return const [];
    final result = await _channel.invokeListMethod<String>(
      'getSupportedAbis',
    );
    return result ?? const [];
  }

  Future<bool> canRequestPackageInstalls() async {
    if (!isAndroid) return false;
    final result = await _channel.invokeMethod<bool>(
      'canRequestPackageInstalls',
    );
    return result ?? false;
  }

  Future<void> openInstallPermissionSettings() async {
    if (!isAndroid) return;
    await _channel.invokeMethod<void>('openInstallPermissionSettings');
  }

  Future<void> installApk(String apkPath) async {
    if (!isAndroid) {
      throw const UpdateInstallException('Updates are only supported on Android.');
    }
    await _channel.invokeMethod<void>('installApk', {'apkPath': apkPath});
  }
}

class UpdateInstallException implements Exception {
  const UpdateInstallException(this.message);

  final String message;

  @override
  String toString() => message;
}
