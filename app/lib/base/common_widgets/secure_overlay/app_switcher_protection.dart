import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'secure_overlay.dart';

class AppSwitcherProtection extends StatefulWidget {
  final Widget child;

  AppSwitcherProtection({required this.child});

  @override
  _AppSwitcherProtectionState createState() => _AppSwitcherProtectionState();
}

class _AppSwitcherProtectionState extends State<AppSwitcherProtection>
    with WidgetsBindingObserver {
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Visibility(
            visible: _lifecycleState != AppLifecycleState.resumed &&
                (Constants.hasAppScreenSheild == 1),
            child: SecureOverlay())
      ],
    );
  }
}
