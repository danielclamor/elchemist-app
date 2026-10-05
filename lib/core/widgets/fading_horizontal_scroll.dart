import 'package:flutter/material.dart';

class FadingHorizontalScroll extends StatefulWidget {
  final Widget child;
  final double fadeWidth;
  final ScrollController? controller;

  const FadingHorizontalScroll({
    super.key,
    required this.child,
    this.fadeWidth = 48.0,
    this.controller,
  });

  @override
  State<FadingHorizontalScroll> createState() => _FadingHorizontalScrollState();
}

class _FadingHorizontalScrollState extends State<FadingHorizontalScroll> {
  late final ScrollController _controller;
  late final bool _ownsController;
  bool _showLeft = false;
  bool _showRight = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _update() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    final left = pos.pixels > 0.5;
    final right = pos.pixels < pos.maxScrollExtent - 0.5;

    if (left != _showLeft || right != _showRight) {
      setState(() {
        _showLeft = left;
        _showRight = right;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _update());
        return false;
      },
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) {
          final f = (widget.fadeWidth / bounds.width).clamp(0.0, 0.5);
          return LinearGradient(
            colors: [
              _showLeft ? Colors.transparent : Colors.white,
              Colors.white,
              Colors.white,
              _showRight ? Colors.transparent : Colors.white,
            ],
            stops: [0.0, f, 1.0 - f, 1.0],
          ).createShader(bounds);
        },
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}
