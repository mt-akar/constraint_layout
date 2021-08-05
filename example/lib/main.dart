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
      height: double.infinity,
      width: double.infinity,
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
            // Constrained(
            //   key: ValueKey("this_rectangle"),
            //   width: 100,
            //   height: 200,
            //   startToStartOf: parent,
            //   topToTopOf: parent,
            //   //padding: ConstraintLayoutEdgeInsets(start: 10),
            //   //margin: ConstraintLayoutEdgeInsets(start: 20, end: 200),
            //   child: _childGenerator(Colors.purple, "This"),
            // ),
            // Constrained(
            //   key: ValueKey("constraintlayout_rectangle"),
            //   width: 200,
            //   height: 200,
            //   bottomToBottomOf: parent,
            //   endToEndOf: parent,
            //   //padding: ConstraintLayoutEdgeInsets(end: 10, bottom: 10),
            //   child: _childGenerator(Colors.purple, "something!"),
            // ),
            // Constrained(
            //   key: ValueKey("is_rectangle"),
            //   width: 0,
            //   height: 0,
            //   topToBottomOf: ValueKey("this_rectangle"),
            //   startToEndOf: ValueKey("this_rectangle"),
            //   bottomToTopOf: ValueKey("constraintlayout_rectangle"),
            //   endToStartOf: ValueKey("constraintlayout_rectangle"),
            //   child: _childGenerator(Colors.purple, "is"),
            // ),
            Constrained(
              key: ValueKey("this_rectangle"),
              width: 100,
              height: 100,
              startToStartOf: parent,
              topToTopOf: parent,
              //padding: ConstraintLayoutEdgeInsets(start: 10),
              //margin: ConstraintLayoutEdgeInsets(start: 20, end: 200),
              child: _childGenerator(Colors.purple, "1"),
            ),
            Constrained(
              key: ValueKey("is_rectangle"),
              width: 50,
              height: 50,
              topToBottomOf: ValueKey("this_rectangle"),
              startToEndOf: ValueKey("this_rectangle"),
              child: _childGenerator(Colors.purple, "2"),
            ),
            Constrained(
              key: ValueKey("constraintlayout_rectangle"),
              width: 150,
              height: 150,
              topToBottomOf: ValueKey("is_rectangle"),
              endToEndOf: parent,
              //padding: ConstraintLayoutEdgeInsets(end: 10, bottom: 10),
              child: _childGenerator(Colors.purple, "3"),
            ),
          ],
        ),
      ),
    );
  }
}
