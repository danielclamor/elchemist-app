import 'dart:math';

import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderNewBlink extends ConsumerStatefulWidget {
  final String orderId;
  final Widget child;

  const ProductionOrderNewBlink({
    super.key,
    required this.orderId,
    required this.child,
  });

  @override
  ConsumerState<ProductionOrderNewBlink> createState() =>
      _ProductionOrderNewBlinkState();
}

class _ProductionOrderNewBlinkState
    extends ConsumerState<ProductionOrderNewBlink>
    with SingleTickerProviderStateMixin {
  static const _blinks = 4;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    ref.listenManual<bool>(
      productionOrderNewIdsProvider
          .select((ids) => ids.contains(widget.orderId)),
      (prev, isNew) {
        if (isNew) _controller.forward(from: 0);
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        // 0 -> 1 -> 0, repeated _blinks times, ends at 0
        final blink = (1 - cos(_controller.value * 2 * pi * _blinks)) / 2;
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
