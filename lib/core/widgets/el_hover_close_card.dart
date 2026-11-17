import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ElHoverCloseCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final Color? color;

  const ElHoverCloseCard({
    super.key,
    required this.child,
    required this.onClose,
    this.color,
  });

  @override
  State<ElHoverCloseCard> createState() => _ElHoverCloseCardState();
}

class _ElHoverCloseCardState extends State<ElHoverCloseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        clipBehavior:
            Clip.none, // Allows the close button to overlap the edge slightly
        children: [
          // Main content
          widget.child,

          // Close button positioned in the top-right corner
          Positioned(
            top: 0,
            bottom: 0,
            right: 8,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _isHovered ? 1.0 : 0.0,
              child: IgnorePointer(
                // Prevents invisible button from capturing clicks when not hovered
                ignoring: !_isHovered,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: widget.onClose,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
