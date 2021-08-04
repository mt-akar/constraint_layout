import 'package:constraint_layout/constraint_layout.dart';
import 'package:flutter/widgets.dart';

class Constrained {
  double? constraintStart;
  double? constraintEnd;
  double? constraintTop;
  double? constraintBottom;
  double? realWidth;
  double? realHeight;
  double realMarginStart;
  double realMarginTop;
  double realMarginEnd;
  double realMarginBottom;

  final ValueKey? key;

  /// If 0 is passed, width is inferred from the constraints.
  /// If match.parent is passed, width same as the parent's width.
  final double width;

  /// If 0 is passed, height is inferred from the constraints.
  /// If match.parent is passed, height same as the parent's height.
  final double height;

  final ValueKey? startToStartOf;
  final ValueKey? endToEndOf;
  final ValueKey? topToTopOf;
  final ValueKey? bottomToBottomOf;
  final ValueKey? startToEndOf;
  final ValueKey? endToStartOf;
  final ValueKey? topToBottomOf;
  final ValueKey? bottomToTopOf;

  final double? marginStart;
  final double? marginTop;
  final double? marginEnd;
  final double? marginBottom;
  final ConstraintLayoutEdgeInsets? margin;

  final double? paddingStart;
  final double? paddingTop;
  final double? paddingEnd;
  final double? paddingBottom;
  final ConstraintLayoutEdgeInsets? padding;

  // final HorizontalFit? horizontalFit;
  // final VerticalFit? verticalFit;
  final Widget child;

  Constrained({
    this.key,
    required this.width,
    required this.height,
    this.startToStartOf,
    this.endToEndOf,
    this.topToTopOf,
    this.bottomToBottomOf,
    this.startToEndOf,
    this.endToStartOf,
    this.topToBottomOf,
    this.bottomToTopOf,
    this.marginStart,
    this.marginTop,
    this.marginEnd,
    this.marginBottom,
    this.margin,
    this.paddingStart,
    this.paddingTop,
    this.paddingEnd,
    this.paddingBottom,
    this.padding,
    required this.child,
  })  : realMarginStart = margin?.start ?? marginStart ?? 0,
        realMarginEnd = margin?.end ?? marginEnd ?? 0,
        realMarginTop = margin?.top ?? marginTop ?? 0,
        realMarginBottom = margin?.bottom ?? marginBottom ?? 0,
        assert(width == match.parent || width == wrap.content || width >= 0, "width cannot be negative"),
        assert(height == match.parent || height == wrap.content || height >= 0, "height cannot be negative");

// TODO: assertions
}
