import 'package:breakpoint3/breakpoint3.dart';
import 'package:flutter/material.dart';

class BreakpointProvider extends InheritedWidget {
  Breakpoint? _breakpoint;

  breakpoint(BuildContext context) =>
      _breakpoint ??= Breakpoint.fromScreen(context);

  BreakpointProvider({
    super.key,
    required super.child,
    Breakpoint? breakpoint,
  }) : _breakpoint = breakpoint;

  @override
  bool updateShouldNotify(BreakpointProvider oldWidget) =>
      breakpoint != oldWidget.breakpoint;
}
