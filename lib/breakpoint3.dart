library breakpoint3;

import 'package:flutter/material.dart';

class Breakpoint {
  final Size size;
  final int columns;
  final double margin;
  final double gutter;
  final double columnSize;
  final Orientation orientation;

  const Breakpoint._(
    this.size,
    this.columns,
    this.margin,
    this.gutter,
    this.columnSize,
    this.orientation,
  );

  factory Breakpoint.fromScreen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final currentOrientation = mediaQuery.orientation;
    final currentScreenSize = mediaQuery.size;
    ScreenSizes currentBreakpoint = ScreenSizes.large;
    final double currentColumnSize;

    for (var breakpoint in ScreenSizes.values) {
      if (breakpoint.minWidth <= currentScreenSize.width) {
        currentBreakpoint = breakpoint;
        continue;
      }
      break;
    }

    currentColumnSize = currentBreakpoint.columnSize(currentScreenSize.width);

    return Breakpoint._(
      currentScreenSize,
      currentBreakpoint.columns,
      currentBreakpoint.margin,
      currentBreakpoint.gutter,
      currentColumnSize,
      currentOrientation,
    );
  }
}

enum ScreenSizes {
  extraSmall(0.0, 599.0, 4, 8),
  small(600.0, 904.0, 12, 12),
  medium(905.0, 1239.0, 12, 16),
  extraMedium(1240.0, 1439.0, 12, 24),
  large(1440.0, double.infinity, 12, 24);

  final double minWidth;
  final double maxWidth;
  final int columns;
  final double margin;

  get gutter => margin;

  columnSize(screenWidth) =>
      (screenWidth - (columns - 1) * gutter + margin * 2) / columns;

  const ScreenSizes(this.minWidth, this.maxWidth, this.columns, this.margin);
}
