import 'dart:math';

import 'package:elchemist_app/core/widgets/el_blinker.dart';
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
    return ElBlinker(
      controller: _controller,
      child: widget.child,
    );
  }
}
