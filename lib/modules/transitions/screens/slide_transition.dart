import 'package:flutter/material.dart';

class SlideTranstionRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  SlideTranstionRoute({this.child, this.direction})
      : super(
            transitionDuration: Duration(milliseconds: 350),
            reverseTransitionDuration: Duration(milliseconds: 350),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
        position: Tween<Offset>(begin: getBeginTransition(), end: Offset.zero)
            .animate(animation),
        child: child);
  }

  Offset getBeginTransition() {
    switch (direction) {
      case AxisDirection.up:
        return Offset(0, 1);
      case AxisDirection.down:
        return Offset(0, -1);
      case AxisDirection.right:
        return Offset(-1, 0);
      case AxisDirection.left:
        return Offset(1, 0);
      default:
        return Offset(1, 0);
    }
  }
}
