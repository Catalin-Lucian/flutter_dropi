import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const CustomLoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  _CustomLoadingOverlayState createState() => _CustomLoadingOverlayState();
}

class _CustomLoadingOverlayState extends State<CustomLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading) _buildLoadingOverlay(context),
      ],
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                _colorAnimation.value!,
              ),
            ),
          ],
        );
      },
    );
  }
}
