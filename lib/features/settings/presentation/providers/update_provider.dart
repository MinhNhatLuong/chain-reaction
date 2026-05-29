import 'dart:async';

import 'package:chain_reaction/core/services/update/update_release.dart';
import 'package:chain_reaction/core/services/update/update_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppUpdateStatus {
  idle,
  checking,
  upToDate,
  available,
  permissionRequired,
  downloading,
  installing,
  installStarted,
  unsupported,
  noRelease,
  error,
}

class AppUpdateState {
  const AppUpdateState({
    required this.status,
    this.availability,
    this.downloadProgress,
    this.message,
  });

  const AppUpdateState.idle()
    : status = AppUpdateStatus.idle,
      availability = null,
      downloadProgress = null,
      message = null;

  final AppUpdateStatus status;
  final UpdateAvailability? availability;
  final double? downloadProgress;
  final String? message;

  bool get isBusy {
    return status == AppUpdateStatus.checking ||
        status == AppUpdateStatus.downloading ||
        status == AppUpdateStatus.installing;
  }

  bool get hasAvailableUpdate {
    return availability != null &&
        (status == AppUpdateStatus.available ||
            status == AppUpdateStatus.permissionRequired ||
            status == AppUpdateStatus.error);
  }

  AppUpdateState copyWith({
    AppUpdateStatus? status,
    UpdateAvailability? availability,
    double? downloadProgress,
    String? message,
    bool clearProgress = false,
    bool clearMessage = false,
  }) {
    return AppUpdateState(
      status: status ?? this.status,
      availability: availability ?? this.availability,
      downloadProgress: clearProgress
          ? null
          : downloadProgress ?? this.downloadProgress,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}

final updateServiceProvider = Provider<UpdateService>((ref) {
  return UpdateService();
});

final appUpdateProvider =
    NotifierProvider<AppUpdateNotifier, AppUpdateState>(
      AppUpdateNotifier.new,
    );

class AppUpdateNotifier extends Notifier<AppUpdateState> {
  late final UpdateService _service;

  @override
  AppUpdateState build() {
    _service = ref.watch(updateServiceProvider);
    return const AppUpdateState.idle();
  }

  Future<void> checkForUpdate() async {
    if (state.isBusy) return;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      state = const AppUpdateState(
        status: AppUpdateStatus.unsupported,
        message: 'APK updates are available on Android only.',
      );
      return;
    }

    state = state.copyWith(
      status: AppUpdateStatus.checking,
      clearProgress: true,
      clearMessage: true,
    );

    try {
      final availability = await _service.checkForUpdate();
      if (availability == null) {
        state = const AppUpdateState(
          status: AppUpdateStatus.upToDate,
          message: 'You are up to date.',
        );
        return;
      }

      state = AppUpdateState(
        status: AppUpdateStatus.available,
        availability: availability,
        message:
            'Build ${availability.release.buildNumber} is ready to install.',
      );
    } on Object catch (error) {
      if (error is NoPublishedUpdateReleaseException) {
        state = AppUpdateState(
          status: AppUpdateStatus.noRelease,
          message: error.message,
        );
        return;
      }

      state = AppUpdateState(
        status: AppUpdateStatus.error,
        message: _messageFor(error),
      );
    }
  }

  Future<void> update() async {
    if (state.isBusy) return;
    final availability = state.availability;
    if (availability == null) return;

    try {
      if (!await _service.canRequestPackageInstalls()) {
        state = state.copyWith(
          status: AppUpdateStatus.permissionRequired,
          message: 'Allow this app to install APK updates, then return here.',
          clearProgress: true,
        );
        await _service.openInstallPermissionSettings();
        return;
      }

      await _downloadAndInstall(availability);
    } on Object catch (error) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        message: _messageFor(error),
        clearProgress: true,
      );
    }
  }

  Future<void> continueAfterPermission() async {
    if (state.status != AppUpdateStatus.permissionRequired) return;
    if (!await _service.canRequestPackageInstalls()) return;

    final availability = state.availability;
    if (availability == null) return;
    try {
      await _downloadAndInstall(availability);
    } on Object catch (error) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        message: _messageFor(error),
        clearProgress: true,
      );
    }
  }

  Future<void> _downloadAndInstall(UpdateAvailability availability) async {
    state = state.copyWith(
      status: AppUpdateStatus.downloading,
      downloadProgress: 0,
      message: 'Downloading ${availability.apkAsset.name}...',
    );

    final apkFile = await _service.downloadAndVerifyApk(
      availability: availability,
      onProgress: (progress) {
        state = state.copyWith(
          status: AppUpdateStatus.downloading,
          downloadProgress: progress,
        );
      },
    );

    state = state.copyWith(
      status: AppUpdateStatus.installing,
      message: 'Opening Android installer...',
      downloadProgress: 1,
    );

    await _service.installApk(apkFile);

    state = state.copyWith(
      status: AppUpdateStatus.installStarted,
      message: 'Installer opened. Complete the system prompt to finish.',
      clearProgress: true,
    );
  }

  String _messageFor(Object error) {
    if (error is UpdateException) return error.message;
    return 'Update failed: $error';
  }
}
