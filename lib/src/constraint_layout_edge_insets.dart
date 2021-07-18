class ConstraintLayoutEdgeInsets {
  final double? start;
  final double? end;
  final double? top;
  final double? bottom;

  const ConstraintLayoutEdgeInsets({
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  ConstraintLayoutEdgeInsets.all(double padding)
      : start = padding,
        top = padding,
        end = padding,
        bottom = padding;
}
