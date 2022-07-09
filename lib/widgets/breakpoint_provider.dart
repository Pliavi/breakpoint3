import 'package:breakpoint3/breakpoint3.dart';
import 'package:flutter/material.dart';

class BreakpointProvider extends InheritedWidget {
  final Breakpoint breakpoint;

  const BreakpointProvider({
    super.key,
    required super.child,
    required this.breakpoint,
  });

  @override
  bool updateShouldNotify(BreakpointProvider oldWidget) =>
      breakpoint != oldWidget.breakpoint;
}
