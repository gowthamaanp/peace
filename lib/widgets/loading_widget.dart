import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OverlayLoader extends StatefulWidget {
  static void show(BuildContext context, {Key? key}) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => OverlayLoader(key: key),
    ).then((_) {
      if (context.mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  static void hide(BuildContext context) => Navigator.pop(context);

  const OverlayLoader({super.key});

  @override
  State<OverlayLoader> createState() => _OverlayLoaderState();
}

class _OverlayLoaderState extends State<OverlayLoader> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 20,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
