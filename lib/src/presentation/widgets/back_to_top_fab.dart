import 'package:flutter/material.dart';

class BackToTopFab extends StatefulWidget {
  const BackToTopFab({super.key, this.controller});

  final ScrollController? controller;

  @override
  State<StatefulWidget> createState() => _BackToTopFabState();
}

class _BackToTopFabState extends State<BackToTopFab> {
  late final ScrollController _scrollController;

  var _showBackToTop = false;

  static const _backToTopScrollOffsetThreshould = 600.0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showBackToTop =
        _scrollController.offset > _backToTopScrollOffsetThreshould;
    if (showBackToTop != _showBackToTop) {
      setState(() => _showBackToTop = showBackToTop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _showBackToTop ? Offset.zero : Offset(0, 5),
      duration: Durations.long1,
      child: FloatingActionButton.small(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: Durations.medium1,
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}
