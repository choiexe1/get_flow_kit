import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({required this.child, this.appBar, super.key});

  final AppBar? appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: child),
    );
  }
}
