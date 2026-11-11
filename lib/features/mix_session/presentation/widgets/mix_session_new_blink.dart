import 'package:elchemist_app/core/widgets/el_blinker.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionNewBlink extends ConsumerStatefulWidget {
  final String mixSessionId;
  final Widget child;

  const MixSessionNewBlink({
    super.key,
    required this.mixSessionId,
    required this.child,
  });

  @override
  ConsumerState<MixSessionNewBlink> createState() => _MixSessionNewBlinkState();
}

class _MixSessionNewBlinkState extends ConsumerState<MixSessionNewBlink>
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
      mixSessionNewIdsProvider
          .select((ids) => ids.contains(widget.mixSessionId)),
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
