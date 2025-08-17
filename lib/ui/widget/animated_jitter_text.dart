import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedJitterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double amplitude;
  final Duration speed;
  final TextAlign textAlign;

  const AnimatedJitterText(
    this.text, {
    super.key,
    this.style,
    this.amplitude = 2.0,
    this.speed = const Duration(milliseconds: 50),
    this.textAlign = TextAlign.start,
  });

  @override
  State<AnimatedJitterText> createState() => _AnimatedJitterTextState();
}

class _AnimatedJitterTextState extends State<AnimatedJitterText> {
  late final Random _random;
  late final List<Offset> _offsets;
  late final Timer _timer;

  late final List<String> _wordsWithSpaces;

  @override
  void initState() {
    super.initState();
    _random = Random();

    _wordsWithSpaces = RegExp(r'(\S+\s*)')
        .allMatches(widget.text)
        .map((m) => m.group(0)!)
        .toList();

    int totalLetters = widget.text.length;
    _offsets = List.generate(
      totalLetters,
      (_) => Offset.zero,
    );

    _timer = Timer.periodic(widget.speed, (_) {
      setState(() {
        for (int i = 0; i < _offsets.length; i++) {
          _offsets[i] = Offset(
            (_random.nextDouble() * 2 - 1) * widget.amplitude,
            (_random.nextDouble() * 2 - 1) * widget.amplitude,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int globalIndex = 0;

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        style: widget.style,
        children: _wordsWithSpaces.map((wordWithSpace) {
          final startIndex = globalIndex;
          globalIndex += wordWithSpace.length;

          return WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(wordWithSpace.length, (i) {
                final letterIndex = startIndex + i;

                return Transform.translate(
                  offset: _offsets[letterIndex],
                  child: Text(
                    wordWithSpace[i],
                    style: widget.style,
                  ),
                );
              }),
            ),
          );
        }).toList(),
      ),
    );
  }
}
