import 'package:constraint_layout/constraint_layout.dart';
import 'package:flutter/widgets.dart';

/// Similar to Android's constraint layout.
class ConstraintLayout extends StatelessWidget {
  final List<Constrained> Function(ValueKey) children;

  const ConstraintLayout({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the children list.
    var constrainedList = children(ValueKey(PARENT_KEY));

    return CustomMultiChildLayout(
      // Delegate that does the heavy lifting.
      delegate: ConstraintLayoutDelegate(constrainedList),
      children: constrainedList.asMap().entries.map((entry) {
        // Create padding
        var padding = _createPadding(entry.value);

        // Create child with padding
        var child = padding != null ? Padding(padding: padding, child: entry.value.child) : entry.value.child;

        // Create LayoutId
        return LayoutId(
          id: entry.key,
          child: child,
        );
      }).toList(),
    );
  }

  EdgeInsetsGeometry? _createPadding(c){
    EdgeInsetsGeometry? padding;
    if (c.padding != null || c.paddingStart != null || c.paddingTop != null || c.paddingEnd != null || c.paddingBottom != null) {
      padding = EdgeInsets.fromLTRB(
        c.padding?.start ?? c.paddingStart ?? 0,
        c.padding?.top ?? c.paddingTop ?? 0,
        c.padding?.end ?? c.paddingEnd ?? 0,
        c.padding?.bottom ?? c.paddingBottom ?? 0,
      );
    }
    return padding;
  }
}
