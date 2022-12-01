import 'package:flutter/material.dart';

class AppLifecycleManager extends StatefulWidget {
  const AppLifecycleManager({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
