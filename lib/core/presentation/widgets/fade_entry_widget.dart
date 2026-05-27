import 'dart:async';

import 'package:flutter/material.dart';

class FadeEntryWidget extends StatefulWidget {
  const FadeEntryWidget({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.verticalOffset = 20.0,
  });
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double verticalOffset;

  @override
  State<FadeEntryWidget> createState() => _FadeEntryWidgetState();
}

class _FadeEntryWidgetState extends State<FadeEntryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.verticalOffset / 100), // Approximate offset
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.delay == Duration.zero) {
      unawaited(_controller.forward());
    } else {
      unawaited(
        Future.delayed(widget.delay, () {
          if (mounted) unawaited(_controller.forward());
        }),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
