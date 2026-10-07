import 'package:flutter/material.dart';

class FadingVerticalScroll extends StatefulWidget {
  final Widget child;
  final double fadeHeight;
  final ScrollController? controller;

  const FadingVerticalScroll({
    super.key,
    required this.child,
    this.fadeHeight = 48.0,
    this.controller,
  });

  @override
  State<FadingVerticalScroll> createState() => _FadingVerticalScrollState();
}

class _FadingVerticalScrollState extends State<FadingVerticalScroll> {
  late final ScrollController _controller;
  late final bool _ownsController;
  bool _showTop = false;
  bool _showBottom = false;

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
    final top = pos.pixels > 0.5;
    final bottom = pos.pixels < pos.maxScrollExtent - 0.5;

    if (top != _showTop || bottom != _showBottom) {
      setState(() {
        _showTop = top;
        _showBottom = bottom;
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
          final f = (widget.fadeHeight / bounds.height).clamp(0.0, 0.5);
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _showTop ? Colors.transparent : Colors.black,
              Colors.black,
              Colors.black,
              _showBottom ? Colors.transparent : Colors.black,
            ],
            stops: [0.0, f, 1.0 - f, 1.0],
          ).createShader(bounds);
        },
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          child: widget.child,
        ),
      ),
    );
  }
}
