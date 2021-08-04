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
      body: ConstraintLayout(
        children: (parent) => [
          Constrained(
            key: ValueKey("this_rectangle"),
            width: 100,
            height: 200,
            startToStartOf: parent,
            topToTopOf: parent,
            //padding: ConstraintLayoutEdgeInsets(start: 10),
            //margin: ConstraintLayoutEdgeInsets(start: 20, end: 20),
            child: _childGenerator(Colors.purple, "This"),
          ),
          Constrained(
            key: ValueKey("constraintlayout_rectangle"),
            width: 200,
            height: 200,
            bottomToBottomOf: parent,
            endToEndOf: parent,
            //padding: ConstraintLayoutEdgeInsets(end: 10, bottom: 10),
            child: _childGenerator(Colors.purple, "ConstraintLayout!"),
          ),
          Constrained(
            key: ValueKey("is_rectangle"),
            width: 0,
            height: 0,
            topToBottomOf: ValueKey("this_rectangle"),
            startToEndOf: ValueKey("this_rectangle"),
            bottomToTopOf: ValueKey("constraintlayout_rectangle"),
            endToStartOf: ValueKey("constraintlayout_rectangle"),
            child: _childGenerator(Colors.purple, "is"),
          ),
          // Constrained(
          //   height: 20,
          //   width: match.parent,
          //   topToTopOf: parent,
          //   startToStartOf: parent,
          //   endToEndOf: ValueKey("is_rectangle"),
          //   // match.parent,
          //   child: _childGenerator(Colors.purple, "top"),
          // ),
          Constrained(
            height: 60,
            width: 0, //wrap.content,
            topToTopOf: parent,
            startToStartOf: parent,
            endToEndOf: parent,
            bottomToBottomOf: parent,
            //margin: ConstraintLayoutEdgeInsets(start: 10, end: 40),
            child: _childGenerator(Colors.purple, "Hello"),
          ),
        ],
      ),
    );
  }
}
