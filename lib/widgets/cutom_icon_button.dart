import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final Color normalColor;
  final Color hoverColor;
  final VoidCallback onClick;
  final double size;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.normalColor,
    required this.hoverColor,
    required this.onClick,
    this.size = 35,
  }) : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: widget.onClick,
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        child: Container(
          width: widget.size, // Adjust the width as desired
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPressed
                ? widget.hoverColor.withOpacity(0.5)
                : (isHovered ? widget.hoverColor : widget.normalColor),
          ), // Adjust the height as desired
          child: Center(
            child: Icon(
              widget.icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
