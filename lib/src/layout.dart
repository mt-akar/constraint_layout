import 'package:constraint_layout/constraint_layout.dart';
import 'package:flutter/widgets.dart';

import 'child_size.dart';

/// Similar to Android's constraint layout.
class ConstraintLayout extends StatelessWidget {
  final List<Constrained> Function(ValueKey) children;

  const ConstraintLayout({Key? key, required this.children}) : super(key: key);

  static const PARENT_KEY = "parent";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var s = Stopwatch();
        s.start();

        //////// Parent setup ///////
        var parentKey = ValueKey(PARENT_KEY);
        var parent = Constrained(
          key: parentKey,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: SizedBox.shrink(),
        );
        parent.constraintStart = 0;
        parent.constraintEnd = constraints.maxWidth;
        parent.constraintTop = 0;
        parent.constraintBottom = constraints.maxHeight;

        /////// Constraint inferring ///////
        // Create the children list.
        var constrainedList = children(parentKey);

        ///////////////////////////////////////////////////
        constrainedList.forEach((pos) {
          print("test ${pos.toString()}");
          var t = SizeProviderWidget(
            onChildSize: (Size size) {
              print("height: ${size.height}, width: ${size.width}");
            },
            child: pos.child,
          );
          pos.realWidth = pos.width == match.parent ? constraints.maxWidth - pos.realMarginStart - pos.realMarginEnd : pos.width;
          pos.realHeight = pos.height == match.parent ? constraints.maxHeight - pos.realMarginTop - pos.realMarginBottom : pos.height;
        });
        ///////////////////////////////////////////////////

        // TODO: Check if there is a duplicate key
        for (int i = 0; i < constrainedList.length; i++) {
          if (constrainedList[i].key == null) {
            continue;
          }
          for (int j = i + 1; j < constrainedList.length; j++) {
            if (constrainedList[i].key == constrainedList[j].key) {
              throw ArgumentError("The key ${constrainedList[i].key} identifies more than 1 item.");
            }
          }
        }

        // Resolve match.parent width and heights.
        constrainedList.forEach((pos) {
          pos.realWidth = pos.width == match.parent ? constraints.maxWidth - pos.realMarginStart - pos.realMarginEnd : pos.width;
          pos.realHeight = pos.height == match.parent ? constraints.maxHeight - pos.realMarginTop - pos.realMarginBottom : pos.height;
        });

        // Add parent to the list so that its dimensions can be inferred just like any other view.
        constrainedList.add(parent);

        var changed = true;
        while (changed) {
          changed = false;

          constrainedList.forEach((pos) {
            //// START ////
            if (pos.constraintStart == null) {
              // Infer from constraint
              if (pos.startToEndOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.startToEndOf);
                if (anchorPos.constraintEnd != null) {
                  pos.constraintStart = anchorPos.constraintEnd! + pos.realMarginStart;
                  changed = true;
                }
              } else if (pos.startToStartOf != null) {
                var anchorPos = constrainedList.firstWhere((element) {
                  return element.key == pos.startToStartOf;
                });
                if (anchorPos.constraintStart != null) {
                  pos.constraintStart = anchorPos.constraintStart! + pos.realMarginStart;
                  changed = true;
                }
              }
              // Infer from end and width
              else if (pos.constraintEnd != null && pos.realWidth != 0) {
                pos.constraintStart = pos.constraintEnd! - pos.realWidth!;
                changed = true;
              }
            }

            //// END ////
            if (pos.constraintEnd == null) {
              // Infer from constraint
              if (pos.endToStartOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.endToStartOf);
                if (anchorPos.constraintStart != null) {
                  pos.constraintEnd = anchorPos.constraintStart! + pos.realMarginEnd;
                  changed = true;
                }
              } else if (pos.endToEndOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.endToEndOf);
                if (anchorPos.constraintEnd != null) {
                  pos.constraintEnd = anchorPos.constraintEnd! + pos.realMarginEnd;
                  changed = true;
                }
              }
              // Infer from start and width
              else if (pos.constraintStart != null && pos.realWidth != 0) {
                pos.constraintEnd = pos.constraintStart! + pos.realWidth!;
                changed = true;
              }
            }

            //// TOP ////
            if (pos.constraintTop == null) {
              // Infer from constraint
              if (pos.topToBottomOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.topToBottomOf);
                if (anchorPos.constraintBottom != null) {
                  pos.constraintTop = anchorPos.constraintBottom! + pos.realMarginTop;
                  changed = true;
                }
              } else if (pos.topToTopOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.topToTopOf);
                if (anchorPos.constraintTop != null) {
                  pos.constraintTop = anchorPos.constraintTop! + pos.realMarginTop;
                  changed = true;
                }
              }
              // Infer from bottom and height
              else if (pos.constraintBottom != null && pos.realHeight != 0) {
                pos.constraintTop = pos.constraintBottom! - pos.realHeight!;
                changed = true;
              }
            }

            //// BOTTOM ////
            if (pos.constraintBottom == null) {
              // Infer from constraint
              if (pos.bottomToTopOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.bottomToTopOf);
                if (anchorPos.constraintTop != null) {
                  pos.constraintBottom = anchorPos.constraintTop! + pos.realMarginBottom;
                  changed = true;
                }
              } else if (pos.bottomToBottomOf != null) {
                var anchorPos = constrainedList.firstWhere((element) => element.key == pos.bottomToBottomOf);
                if (anchorPos.constraintBottom != null) {
                  pos.constraintBottom = anchorPos.constraintBottom! + pos.realMarginBottom;
                  changed = true;
                }
              }
              // Infer from top and height
              else if (pos.constraintTop != null && pos.realHeight != 0) {
                pos.constraintBottom = pos.constraintTop! + pos.realHeight!;
                changed = true;
              }
            }
          });
        }

        /////// Cleanup ///////
        // Finally remove the parent. It is now drawn
        constrainedList.removeLast();

        print("Elapsed: ${s.elapsed}");

        /////// Stack construction ///////
        return Stack(
          children: constrainedList.map((e) {
            var child = Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: e.realWidth == 0 ? e.constraintEnd! - e.constraintStart! : e.realWidth!,
                  maxWidth: e.realWidth == 0 ? e.constraintEnd! - e.constraintStart! : e.realWidth!,
                  minHeight: e.realHeight == 0 ? e.constraintBottom! - e.constraintTop! : e.realHeight!,
                  maxHeight: e.realHeight == 0 ? e.constraintBottom! - e.constraintTop! : e.realHeight!,
                ),
                child: e.child,
              ),
            );

            EdgeInsetsGeometry? padding;

            if (e.padding != null || e.paddingStart != null || e.paddingTop != null || e.paddingEnd != null || e.paddingBottom != null) {
              padding = EdgeInsets.fromLTRB(
                e.padding?.start ?? e.paddingStart ?? 0,
                e.padding?.top ?? e.paddingTop ?? 0,
                e.padding?.end ?? e.paddingEnd ?? 0,
                e.padding?.bottom ?? e.paddingBottom ?? 0,
              );
            }

            // Positioned.fill values
            var left = e.realWidth! > e.constraintEnd! - e.constraintStart! ? (e.constraintEnd! + e.constraintStart! - e.realWidth!) / 2 : e.constraintStart!;
            var right = e.realWidth! > e.constraintEnd! - e.constraintStart! ? (e.constraintEnd! + e.constraintStart! + e.realWidth!) / 2 : e.constraintEnd!;

            var top = e.realHeight! > e.constraintBottom! - e.constraintTop! ? (e.constraintBottom! + e.constraintTop! - e.realHeight!) / 2 : e.constraintTop!;
            var bottom = e.realHeight! > e.constraintBottom! - e.constraintTop! ? (e.constraintBottom! + e.constraintTop! + e.realHeight!) / 2 : e.constraintBottom!;

            // Construct [Positioned] widgets.
            //
            // Map end to right and bottom to bottom because in [Positioned] syntax,
            // right and bottom are distance from the right and bottom of the [Stack].
            return Positioned.fill(
              left: left,
              right: constraints.maxWidth - right,
              top: top,
              bottom: constraints.maxHeight - bottom,
              child: padding != null ? Padding(padding: padding, child: child) : child,
            );
          }).toList(),
        );
      },
    );
  }
}
