import 'package:constraint_layout/constraint_layout.dart';
import 'package:flutter/widgets.dart';

class ConstraintLayoutDelegate extends MultiChildLayoutDelegate {
  final List<Constrained> constrainedList;

  ConstraintLayoutDelegate(this.constrainedList);

  @override
  void performLayout(Size size) {
    // Measure time
    var s = Stopwatch()..start();

    //////// Find width and height ///////
    constrainedList.asMap().entries.forEach((pos) {
      if (pos.value.width != wrapContent) pos.value.realWidth = pos.value.width == matchParent ? size.width - pos.value.finalMarginStart - pos.value.finalMarginEnd : pos.value.width;
      if (pos.value.height != wrapContent) pos.value.realHeight = pos.value.height == matchParent ? size.height - pos.value.finalMarginTop - pos.value.finalMarginBottom : pos.value.height;
      if (pos.value.width != wrapContent && pos.value.height != wrapContent)
        layoutChild(
          pos.key,
          BoxConstraints.tightFor(
            width: pos.value.realWidth!,
            height: pos.value.realHeight!,
          ),
        );
      else if (pos.value.width != wrapContent && pos.value.height == wrapContent) {
        var size = layoutChild(
          pos.key,
          BoxConstraints.tightFor(
            width: pos.value.realWidth!,
          ),
        );

        pos.value.realHeight = size.height;
      } else if (pos.value.width == wrapContent && pos.value.height != wrapContent) {
        var size = layoutChild(
          pos.key,
          BoxConstraints.tightFor(
            height: pos.value.realHeight!,
          ),
        );

        pos.value.realWidth = size.width;
      }
    });

    //////// Parent setup ///////
    var parent = Constrained(
      key: ValueKey(PARENT_KEY),
      width: size.width,
      height: size.height,
      child: SizedBox.shrink(),
    );
    parent.constraintStart = 0;
    parent.constraintEnd = size.width;
    parent.constraintTop = 0;
    parent.constraintBottom = size.height;

    // Add parent to the list so that its dimensions can be inferred just like any other view.
    constrainedList.add(parent);

    //////// Constraint inferring ///////
    var changed = true;
    while (changed) {
      changed = false;

      constrainedList.forEach((c) {
        //// START ////
        if (c.constraintStart == null) {
          // Infer from constraint
          if (c.startToEndOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.startToEndOf);
            if (anchorPos.constraintEnd != null) {
              c.constraintStart = anchorPos.constraintEnd! + c.finalMarginStart;
              changed = true;
            }
          } else if (c.startToStartOf != null) {
            var anchorPos = constrainedList.firstWhere((element) {
              return element.key == c.startToStartOf;
            });
            if (anchorPos.constraintStart != null) {
              c.constraintStart = anchorPos.constraintStart! + c.finalMarginStart;
              changed = true;
            }
          }
          // Infer from end and width
          else if (c.constraintEnd != null && c.realWidth != null && c.realWidth! > 0) {
            c.constraintStart = c.constraintEnd! - c.realWidth!;
            changed = true;
          }
        }

        //// END ////
        if (c.constraintEnd == null) {
          // Infer from constraint
          if (c.endToStartOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.endToStartOf);
            if (anchorPos.constraintStart != null) {
              c.constraintEnd = anchorPos.constraintStart! + c.finalMarginEnd;
              changed = true;
            }
          } else if (c.endToEndOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.endToEndOf);
            if (anchorPos.constraintEnd != null) {
              c.constraintEnd = anchorPos.constraintEnd! + c.finalMarginEnd;
              changed = true;
            }
          }
          // Infer from start and width
          else if (c.constraintStart != null && c.realWidth != null && c.realWidth! > 0) {
            c.constraintEnd = c.constraintStart! + c.realWidth!;
            changed = true;
          }
        }

        //// TOP ////
        if (c.constraintTop == null) {
          // Infer from constraint
          if (c.topToBottomOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.topToBottomOf);
            if (anchorPos.constraintBottom != null) {
              c.constraintTop = anchorPos.constraintBottom! + c.finalMarginTop;
              changed = true;
            }
          } else if (c.topToTopOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.topToTopOf);
            if (anchorPos.constraintTop != null) {
              c.constraintTop = anchorPos.constraintTop! + c.finalMarginTop;
              changed = true;
            }
          }
          // Infer from bottom and height
          else if (c.constraintBottom != null && c.realHeight != null && c.realHeight! > 0) {
            c.constraintTop = c.constraintBottom! - c.realHeight!;
            changed = true;
          }
        }

        //// BOTTOM ////
        if (c.constraintBottom == null) {
          // Infer from constraint
          if (c.bottomToTopOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.bottomToTopOf);
            if (anchorPos.constraintTop != null) {
              c.constraintBottom = anchorPos.constraintTop! + c.finalMarginBottom;
              changed = true;
            }
          } else if (c.bottomToBottomOf != null) {
            var anchorPos = constrainedList.firstWhere((element) => element.key == c.bottomToBottomOf);
            if (anchorPos.constraintBottom != null) {
              c.constraintBottom = anchorPos.constraintBottom! + c.finalMarginBottom;
              changed = true;
            }
          }
          // Infer from top and height
          else if (c.constraintTop != null && c.realHeight != null && c.realHeight! > 0) {
            c.constraintBottom = c.constraintTop! + c.realHeight!;
            changed = true;
          }
        }
      });
    }

    /////// Cleanup ///////
    // Finally remove the parent. It is now drawn
    constrainedList.removeLast();

    print("Elapsed: ${s.elapsed}");

    /////// Position the child ///////
    constrainedList.asMap().entries.forEach((entry) {
      positionChild(
        entry.key,
        Offset(
          (entry.value.constraintEnd! + entry.value.constraintStart! - entry.value.realWidth!) / 2, // left
          (entry.value.constraintBottom! + entry.value.constraintTop! - entry.value.realHeight!) / 2, // top
        ),
      );
    });
  }

  @override
  bool shouldRelayout(ConstraintLayoutDelegate oldDelegate) {
    return false;
  }
}
