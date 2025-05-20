import 'package:fleet_monitoring_app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/app_config.dart';
import 'core/config/preferences.dart';
import 'core/routes/app_route.dart';
import 'core/routes/route_generator.dart';

Future<void> main() async {
  await dotenv.load();                       // <‑‑ reads .env
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoute.home,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
