import 'package:bio_secure/presentation/pages/splash_screen_refactored.dart';
import 'package:bio_secure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bio_secure/core/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all dependencies
  await ServiceLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BioSecure',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreenRefactored(),
      ),
    );
  }
}
