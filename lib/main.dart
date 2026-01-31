import 'package:flutter/material.dart';
import 'package:zygo/core/theme/app_theme.dart';
import 'package:zygo/presentation/pages/splash/splash_page.dart';
import 'package:zygo/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initilizeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zygo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: SplashPage(),
    );
  }
}

