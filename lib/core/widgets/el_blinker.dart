import 'dart:math';

import 'package:flutter/material.dart';

class ElBlinker extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final int blinks;

  const ElBlinker({
    super.key,
    required this.controller,
    required this.child,
    this.blinks = 4,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        // 0 -> 1 -> 0, repeated _blinks times, ends at 0
        final blink = (1 - cos(controller.value * 2 * pi * blinks)) / 2;
        return DecoratedBox(
          position: DecorationPosition.foreground,
          decoration:
              BoxDecoration(color: color.withValues(alpha: 0.3 * blink)),
          child: child,
        );
      },
    );
  }
}
