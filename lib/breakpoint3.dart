library breakpoint3;

import 'package:breakpoint3/widgets/breakpoint_provider.dart';
import 'package:flutter/material.dart';

// TODO: Change name to BreakpointData
// and probably BreakpntProvider to only Breakpoint
class Breakpoint {
  final Size size;
  final int columns;
  final double margin;
  final double gutter;
  final double columnSize;
  final Orientation orientation;
  final Map<String, BreakpointDefinition> breakpoints;

  const Breakpoint._(
    this.size,
    this.columns,
    this.margin,
    this.gutter,
    this.columnSize,
    this.orientation,
    this.breakpoints,
  );

  factory Breakpoint.fromScreen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final currentOrientation = mediaQuery.orientation;
    final currentScreenSize = mediaQuery.size;

    return _calculateBreakpoint(
      currentScreenSize,
      currentOrientation,
    );
  }

  static Breakpoint _calculateBreakpoint(
    Size currentScreenSize, [
    Orientation? currentOrientation,
  ]) {
    // TODO: calculate currentOrientation if necessary
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
      currentOrientation!,
      // TODO: use the breakpoint definitions from the config file
      Map(),
    );
  }

  /// Return the breakpoint from the given [BoxConstraints] of the Widget
  /// conforming with the screen size.
  factory Breakpoint.fromWidget(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final currentOrientation = mediaQuery.orientation;
    final currentScreenSize = mediaQuery.size;
    final currentWidgetSize = constraints.biggest;

    final currentBreakpoint = _calculateBreakpoint(
          currentScreenSize,
          currentOrientation,
        ) -
        _calculateBreakpoint(
          currentWidgetSize,
          currentOrientation,
        );

    return currentBreakpoint!;
  }

  /// Returns the breakpoint from the given [BoxConstraints]
  /// NOT based on the screen size.
  ///
  /// @warn this fully unrecommended! Use [Breakpoint.fromWidget] instead!!
  /// Use this method only if you know what you are doing!!!
  ///
  /// It will calculate the breakpoint as the given constrainst is the screen
  /// So it will break all the layout rules!
  /// From here are only you and god, I will not be responsible for anything!
  factory Breakpoint.dangerouslyFromConstraints(BoxConstraints constraints) {
    return _calculateBreakpoint(constraints.biggest);
  }

  static Breakpoint of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BreakpointProvider>()!
        .breakpoint(context);
  }

  Breakpoint? operator -(Breakpoint other) => null;
}

abstract class BreakpointDefinition {
  final double maxWidth;
  final int columns;
  final double margin;
  final double gutter;

  BreakpointDefinition({
    required this.maxWidth,
    required this.columns,
    required this.margin,
    required this.gutter,
  });
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
