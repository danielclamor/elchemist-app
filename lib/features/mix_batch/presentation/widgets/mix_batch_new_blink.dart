import 'dart:math';

import 'package:elchemist_app/core/widgets/el_blinker.dart';
import 'package:elchemist_app/features/mix_batch/presentation/providers/mix_batch_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixBatchNewBlink extends ConsumerStatefulWidget {
  final String mixBatchId;
  final Widget child;

  const MixBatchNewBlink({
    super.key,
    required this.mixBatchId,
    required this.child,
  });

  @override
  ConsumerState<MixBatchNewBlink> createState() => _MixBatchNewBlinkState();
}

class _MixBatchNewBlinkState extends ConsumerState<MixBatchNewBlink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    ref.listenManual<bool>(
      mixBatchNewIdsProvider.select((ids) => ids.contains(widget.mixBatchId)),
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
