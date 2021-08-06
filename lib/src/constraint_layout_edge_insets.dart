class ConstrainedEdgeInsets {
  final double? start;
  final double? end;
  final double? top;
  final double? bottom;

  const ConstrainedEdgeInsets({
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  ConstrainedEdgeInsets.all(double padding)
      : start = padding,
        top = padding,
        end = padding,
        bottom = padding;
}
