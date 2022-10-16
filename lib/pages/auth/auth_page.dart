import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final Widget child;
  const AuthPage({Key? key, required this.child}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
          opacity: _animation,
          child: widget.child,
        );
  }
}
