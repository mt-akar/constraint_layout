import 'package:constraint_layout/constraint_layout.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: ConstLayTrial(),
      ),
    );

class ConstLayTrial extends StatelessWidget {
  const ConstLayTrial({Key? key}) : super(key: key);

  Widget _childGenerator(MaterialColor color, String s) {
    return Container(
      height: 30,
      width: 30,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color[700]!,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color[100]!,
        ),
        child: Center(
          child: Text(s),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstraintLayout(
          children: (parent) => [
            Constrained(
              key: ValueKey("1"),
              width: 50,
              height: 100,
              startToStartOf: parent,
              topToTopOf: parent,
              padding: ConstrainedEdgeInsets(start: 10),
              margin: ConstrainedEdgeInsets(start: 10, end: 200),
              child: _childGenerator(Colors.purple, "1"),
            ),
            Constrained(
              key: ValueKey("2"),
              width: 50,
              height: 50,
              topToBottomOf: ValueKey("1"),
              startToEndOf: ValueKey("1"),
              child: _childGenerator(Colors.purple, "2"),
            ),
            Constrained(
              key: ValueKey("3"),
              width: 150,
              height: 150,
              topToBottomOf: ValueKey("2"),
              endToEndOf: parent,
              padding: ConstrainedEdgeInsets(end: 10),
              child: _childGenerator(Colors.purple, "3"),
            ),
            Constrained(
              key: ValueKey("4"),
              width: 200,
              height: wrapContent,
              topToBottomOf: ValueKey("3"),
              startToStartOf: parent,
              endToEndOf: parent,
              child: _childGenerator(Colors.purple, "4"),
            ),
          ],
        ),
      ),
    );
  }
}
