import 'package:flutter/material.dart';

class CustomLanguageButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomLanguageButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  _CustomLanguageButtonState createState() => _CustomLanguageButtonState();
}

class _CustomLanguageButtonState extends State<CustomLanguageButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          color: _isPressed
              ? const Color.fromRGBO(71, 16, 135, 1)
              : const Color.fromRGBO(88, 193, 144, 1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isPressed
                ? const Color.fromRGBO(88, 193, 144, 1)
                : const Color.fromRGBO(88, 193, 144, 1),
            width: _isPressed ? 2 : 0,
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
