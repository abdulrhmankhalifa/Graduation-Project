import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class OverflowText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextOverflow overflow;
  final Function(String overflowText) onOverflow;

  const OverflowText({
    Key? key,
    required this.text,
    required this.style,
    required this.overflow,
    required this.onOverflow,
  }) : super(key: key);

  @override
  _OverflowTextState createState() => _OverflowTextState();
}

class _OverflowTextState extends State<OverflowText> {
  String? overflowText;

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: double.infinity);

    if (textPainter.width > MediaQuery.of(context).size.width) {
      overflowText = widget.text.substring(0, 20) + '...';
      widget.onOverflow(overflowText!);
    }

    return Text(
      widget.text,
      style: widget.style,
      overflow: widget.overflow,
    );
  }
}