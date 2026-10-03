import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<T?> push<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));

Future<T?> pushReplacement<T>(BuildContext context, Widget page) =>
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
