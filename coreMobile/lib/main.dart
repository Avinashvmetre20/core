import 'package:flutter/material.dart';
import 'package:core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = await createAuthController();
  runApp(CoreApp(auth: auth));
}
