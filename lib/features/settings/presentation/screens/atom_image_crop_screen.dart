import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AtomImageCropScreen extends ConsumerStatefulWidget {
  const AtomImageCropScreen({
    required this.imageBytes,
    required this.slotNumber,
    super.key,
  });

  final Uint8List imageBytes;
  final int slotNumber;

  @override
  ConsumerState<AtomImageCropScreen> createState() =>
      _AtomImageCropScreenState();
}

class _AtomImageCropScreenState extends ConsumerState<AtomImageCropScreen> {
  final CropController _cropController = CropController();
  var _isCropping = false;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return ColoredBox(
      color: theme.bg,
      child: ResponsiveContainer(
        child: Scaffold(
          backgroundColor: theme.bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: theme.fg,
                size: AppDimensions.iconM,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Crop orb ${widget.slotNumber}',
              style: TextStyle(
                color: theme.fg,
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.surface,
                        border: Border.all(color: theme.border),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                        child: Crop(
                          image: widget.imageBytes,
                          controller: _cropController,
                          onCropped: _handleCropped,
                          aspectRatio: 1,
                          withCircleUi: true,
                          fixCropRect: true,
                          interactive: true,
                          maskColor: Colors.black.withValues(alpha: 0.55),
                          baseColor: theme.surface,
                          progressIndicator: Center(
                            child: CircularProgressIndicator(color: theme.fg),
                          ),
                          cornerDotBuilder: (size, edgeAlignment) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.fg,
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  Row(
                    children: [
                      Expanded(
                        child: PillButton(
                          text: 'Cancel',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        child: PillButton(
                          text: _isCropping ? 'Cropping...' : 'Use image',
                          onTap: _isCropping
                              ? null
                              : () {
                                  setState(() => _isCropping = true);
                                  _cropController.cropCircle();
                                },
                          type: PillButtonType.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCropped(CropResult result) async {
    switch (result) {
      case CropSuccess(:final croppedImage):
        final resized = await _resizeImage(croppedImage);
        if (!mounted) return;
        Navigator.of(context).pop(resized);
      case CropFailure():
        if (!mounted) return;
        setState(() => _isCropping = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not crop this image.')),
        );
    }
  }

  Future<Uint8List> _resizeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 384,
      targetHeight: 384,
    );
    try {
      final frame = await codec.getNextFrame();
      final byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      frame.image.dispose();
      return byteData?.buffer.asUint8List() ?? bytes;
    } finally {
      codec.dispose();
    }
  }
}
