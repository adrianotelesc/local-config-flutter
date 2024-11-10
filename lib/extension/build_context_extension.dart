import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  double get bottomSheetBottomPadding {
    final mediaQuery = MediaQuery.of(this);
    return mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom;
  }
}
