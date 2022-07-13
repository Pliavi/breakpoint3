import 'package:breakpoint3/breakpoint3.dart';
import 'package:flutter/material.dart';

class SeparatedRow extends StatelessWidget {
  const SeparatedRow({
    Key? key,
    required this.childColumnSize,
    this.children = const [],
    this.canWrap = false,
  }) : super(key: key);

  // TODO: Will fractional sizes be supported?
  final int childColumnSize;
  final List<Widget> children;
  final bool canWrap;

  List<Widget> _createRowColumns(Breakpoint breakpoint) {
    final widgetWidth = childColumnSize * breakpoint.columnSize +
        (childColumnSize - 1) * breakpoint.gutter;

    List<Widget> localChildren = [];

    for (var i = 0; i < children.length; i++) {
      localChildren.add(
        SizedBox(
          width: widgetWidth,
          child: children[i],
        ),
      );
    }

    return localChildren;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final breakpoint = Breakpoint.fromWidget(context, constraints);
      if (!canWrap && breakpoint.columns < children.length / childColumnSize) {
        throw Exception(
          'Too many children for this row, try setting [canWrap] property to [true]',
        );
      }

      if (canWrap) {
        return Wrap(
          runSpacing: breakpoint.gutter,
          spacing: breakpoint.gutter,
          children: _createRowColumns(breakpoint),
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _createRowColumns(breakpoint),
        );
      }
    });
  }
}
