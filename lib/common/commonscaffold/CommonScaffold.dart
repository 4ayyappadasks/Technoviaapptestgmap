import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appbars;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool useSafeArea;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatloc;

  const CommonScaffold({
    Key? key,
    this.body,
    this.appbars,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.useSafeArea = true,
    this.backgroundColor,
    this.floatloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbars,
      body: useSafeArea
          ? SafeArea(
              child: body ?? const SizedBox.shrink(),
            )
          : body ?? const SizedBox.shrink(),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: floatloc,
    );
  }
}
